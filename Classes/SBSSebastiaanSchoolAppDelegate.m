// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.

#import "SBSSebastiaanSchoolAppDelegate.h"
#import "SBSInfoViewController.h"

#import "SBSAgendaItem.h"
#import "SBSBulletin.h"
#import "SBSContactItem.h"
#import "SBSNewsLetter.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

typedef NS_ENUM (NSInteger, SBSNotificationType) {
    SBSNotificationTypeInfo = 0,
    SBSNotificationTypeNewsletter = 1,
    SBSNotificationTypeBulletin = 2,
    SBSNotificationTypeStaff = 3,
};

@interface SBSSebastiaanSchoolAppDelegate ()
@property (strong, readonly) SBSInfoViewController* infoViewController;
@end

@implementation SBSSebastiaanSchoolAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SBSAgendaItem  registerSubclass];
    [SBSBulletin    registerSubclass];
    [SBSContactItem registerSubclass];
    [SBSNewsLetter  registerSubclass];
    
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackground];
        
    PFACL *defaultACL = [PFACL ACL];

    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [defaultACL setWriteAccess:YES forRoleWithName:@"staff"];
    [defaultACL setReadAccess:YES forRoleWithName:@"staff"];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
	
	[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [Fabric with:@[CrashlyticsKit]];

    // Apply UIAppearance
    self.window.tintColor = [SBSStyle sebastiaanBlueColor];
    [[UINavigationBar appearance] setBarTintColor:[SBSStyle sebastiaanBlueColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] }];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    self.rootViewController = (UINavigationController *)self.window.rootViewController;
    [self.window makeKeyAndVisible];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    [self handleRemoteNotification:notificationPayload];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [[PFInstallation currentInstallation] addUniqueObject:@"" forKey:@"channels"];
#ifdef DEBUG
    [[PFInstallation currentInstallation] addUniqueObject:@"debug" forKey:@"channels"];
#endif
    [[PFInstallation currentInstallation] saveEventually];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
	[PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    [self handleRemoteNotification:userInfo];

    //When we are in app and receive a push, we reset the badge to kick the notification out of notification center.
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
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

- (void)handleRemoteNotification:(NSDictionary *) notificationPayload {
    if (notificationPayload == nil) {
        return;
    }
    // Extract the notification data
    NSNumber * notificationType = [notificationPayload objectForKey:@"t"];
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


#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"Sebastiaan app successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"Sebastiaan app failed to subscribe to push notifications on the broadcast channel.");
    }
}

#pragma mark - UIResponder+SBS overrides

- (void) displayActionSheet:(UIActionSheet *)actionSheet {
    [actionSheet showInView:self.rootViewController.view];
}


@end
