//
//  SBSStaffViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//

@interface SBSStaffViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;

- (IBAction)logOutButtonTapAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
