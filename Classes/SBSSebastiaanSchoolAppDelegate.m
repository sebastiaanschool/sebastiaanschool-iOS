// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.

#import <OneSignal/OneSignal.h>

#import <ParseCrashReporting/ParseCrashReporting.h>

#import "SBSSebastiaanSchoolAppDelegate.h"
#import "SBSInfoViewController.h"

#import "SBSAgendaItem.h"
#import "SBSBulletin.h"
#import "SBSContactItem.h"
#import "SBSNewsLetter.h"

typedef NS_ENUM (NSInteger, SBSNotificationType) {
    SBSNotificationTypeInfo = 0,
    SBSNotificationTypeNewsletter = 1,
    SBSNotificationTypeBulletin = 2,
    SBSNotificationTypeStaff = 3,
};

@interface SBSSebastiaanSchoolAppDelegate ()
@property (strong, readonly) SBSInfoViewController* infoViewController;
@property (strong, nonatomic) OneSignal *oneSignal;
@end

@implementation SBSSebastiaanSchoolAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SBSAgendaItem  registerSubclass];
    [SBSBulletin    registerSubclass];
    [SBSContactItem registerSubclass];
    [SBSNewsLetter  registerSubclass];
    
    [ParseCrashReporting enable];
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    [PFUser enableRevocableSessionInBackground];
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFUser logOut];
    }

    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setWriteAccess:YES forRoleWithName:@"staff"];
    [defaultACL setReadAccess:YES forRoleWithName:@"staff"];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
	
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Apply UIAppearance
    self.window.tintColor = [SBSStyle sebastiaanBlueColor];
    [[UINavigationBar appearance] setBarTintColor:[SBSStyle sebastiaanBlueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    self.rootViewController = (UINavigationController *)self.window.rootViewController;
    [self.window makeKeyAndVisible];
    
    
    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                        appId:ONESIGNAL_APP_ID
                                           handleNotification:^(NSString* message, NSDictionary* additionalData, BOOL isActive) {
                                               NSLog(@"OneSignal Notification opened:\nMessage: %@", message);
                                               
                                               if (additionalData) {
                                                   NSLog(@"additionalData: %@", additionalData);
                                                   
                                                   // Extract the notification data
                                                   NSString* notificationType = additionalData[@"t"];
                                                   
                                                   if (notificationType == nil) {
                                                       return;
                                                   }

                                                   switch ((SBSNotificationType)notificationType.intValue) {
                                                       case SBSNotificationTypeBulletin:
                                                           [self.rootViewController popToRootViewControllerAnimated:NO];
                                                           [self.infoViewController buttonTapped:self.infoViewController.bulletinButton];
                                                           break;
                                                       case SBSNotificationTypeNewsletter:
                                                           [self.rootViewController popToRootViewControllerAnimated:NO];
                                                           [self.infoViewController buttonTapped:self.infoViewController.newsButton];
                                                           break;
                                                       case SBSNotificationTypeInfo:
                                                       case SBSNotificationTypeStaff:
                                                           NSLog(@"Unhandled notification: %i", notificationType.intValue);
                                                           break;
                                                   }
                                               }
                                           }];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self trackEvent:@"Handling background fetch."];

    if (userInfo == nil) {
        completionHandler(UIBackgroundTaskInvalid);
        return;
    }
    
    PFQuery *query;
    // Extract the notification data
    NSNumber * notificationType = [userInfo objectForKey:@"t"];
    switch ((SBSNotificationType)notificationType.intValue) {
        case SBSNotificationTypeBulletin:
            query = [PFQuery queryWithClassName:[SBSBulletin parseClassName]];
            [query orderByDescending:@"createdAt"];
            break;
        case SBSNotificationTypeNewsletter:
            query = [PFQuery queryWithClassName:[SBSNewsLetter parseClassName]];
            [query orderByDescending:@"publishedAt"];
            break;
        case SBSNotificationTypeInfo:
        case SBSNotificationTypeStaff:
            NSLog(@"Unhandled notification: %i", notificationType.intValue);
            completionHandler(UIBackgroundTaskInvalid);
            return;
            break;
    }
    
    // Force the query to hit the network, but populate the cache on success.
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    
    // Execute the query in the background. When it's done, tell iOS that the content has been fetched & it's time
    // to display the notification.
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error handling background fetch for notification: %@", error);
            completionHandler(UIBackgroundFetchResultFailed);
        } else {
            NSLog(@"Handling background fetch succeeded.");
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.infoViewController updateBarButtonItemAnimated:YES];
    //When we activate the app, no matter why, we always reset the notification center.
    application.applicationIconBadgeNumber = 0;
}

- (SBSInfoViewController *) infoViewController {
    UIViewController * topViewController = self.rootViewController.viewControllers[0];
    
    NSAssert([topViewController isKindOfClass:[SBSInfoViewController class]], @"Top view controller in the navigation hierarchy should always be a SBSInfoViewController.");
    return (SBSInfoViewController *)topViewController;
}

#pragma mark - UIResponder+SBS overrides

- (void) displayActionSheet:(UIActionSheet *)actionSheet {
    [actionSheet showInView:self.rootViewController.view];
}


@end
