//
//  SBSStaffViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//

#import "SBSStaffViewController.h"

@implementation SBSStaffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }

    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Loaded VC %@", self.title]];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateState];
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self updateState];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    ULog(@"Failed to log in...");
    
    [self updateState];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self updateState];
}


#pragma mark - Logout button handler

- (IBAction)logOutButtonTapAction:(id)sender {    
    if ([PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        logInViewController.title = NSLocalizedString(@"Login", nil);
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton;
        
        // Present the log in view controller
        [self.navigationController pushViewController:logInViewController animated:YES];
    } else {
        [PFUser logOut];
    }
    
    [self updateState];
}

-(void)updateState {
    [[SBSSecurity instance]reset];

    if (![PFAnonymousUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.welcomeLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [[PFUser currentUser] username]]];
        [self.loginButton setTitle:NSLocalizedString(@"Sign out", nil)forState:UIControlStateNormal];
    } else {
        [self.welcomeLabel setText:NSLocalizedString(@"Not logged in", nil)];
        [self.loginButton setTitle:NSLocalizedString(@"Sign in...", nil)forState:UIControlStateNormal];
    }
}

@end
