// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSInfoViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//

#import "SBSInfoViewController.h"

#import "SBSAgendaTableViewController.h"
#import "SBSTeamTableViewController.h"
#import "SBSNewsLetterTableViewController.h"
#import "SBSBulletinViewController.h"
#import "SBSStaffViewController.h"
#import "SebastiaanStyleKit.h"

@interface SBSInfoViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *staffBarButton;

@end

@implementation SBSInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self applyTitle:NSLocalizedString(@"Call", nil) toButton:self.callButton];
    [self.callButton setImage:[SebastiaanStyleKit imageOfPhoneIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    [self applyTitle:NSLocalizedString(@"@KBSebastiaan", nil) toButton:self.twitterButton];
    [self.twitterButton setImage:[SebastiaanStyleKit imageOfTwitterIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];

    [self applyTitle:NSLocalizedString(@"Yurl site", nil) toButton:self.yurlButton];
    [self.yurlButton setImage:[SebastiaanStyleKit imageOfBinocularsIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    [self applyTitle:NSLocalizedString(@"Agenda", nil) toButton:self.agendaButton];
    [self.agendaButton setImage:[SebastiaanStyleKit imageOfListIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    [self applyTitle:NSLocalizedString(@"Team", nil) toButton:self.teamButton];
    [self.teamButton setImage:[SebastiaanStyleKit imageOfGroupIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    [self applyTitle:NSLocalizedString(@"Newsletter", nil) toButton:self.newsButton];
    [self.newsButton setImage:[SebastiaanStyleKit imageOfReceiptIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    [self applyTitle:NSLocalizedString(@"Bulletin", nil) toButton:self.bulletinButton];
    [self.bulletinButton setImage:[SebastiaanStyleKit imageOfBroadcastIconWithFrame:CGRectMake(0, 0, 30, 30)] forState:UIControlStateNormal];
    
    
    UILongPressGestureRecognizer * bonusLongPressRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(doTapOnIcon:)];
    [self.iconImageView addGestureRecognizer:bonusLongPressRecognizer];

    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doBonusTapOnIcon:)];
    [self.iconImageView addGestureRecognizer:tapRecognizer];

    self.iconImageView.userInteractionEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLayout];
}

-(void)updateBarButtonItemAnimated:(BOOL)animated {
    if ([NSUserDefaults enableStaffLogin]) {
        if (self.staffBarButton == nil) {
            self.staffBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Staff", nil) style:UIBarButtonItemStylePlain target:self action:@selector(buttonTapped:)];
            [self.navigationItem setRightBarButtonItem:self.staffBarButton animated:animated];
        }
    } else {
        self.staffBarButton = nil;
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayout];
}

- (void) updateLayout {
    const CGFloat halfViewWidth = self.view.bounds.size.width / 2.0f;
    
    CGRect twitterFrame = self.twitterButton.frame;
    twitterFrame.size.width = halfViewWidth - 20.0f - 5.0f;
    twitterFrame.origin.x = 20.0f;
    self.twitterButton.frame = twitterFrame;
    
    CGRect yurlFrame = self.yurlButton.frame;
    yurlFrame.size.width = halfViewWidth - 20.0f - 5.0f;
    yurlFrame.origin.x = halfViewWidth + 5.0f;
    self.yurlButton.frame = yurlFrame;
    
    self.iconImageView.center = CGPointMake(halfViewWidth, twitterFrame.origin.y / 2.0f);
}

-(void)doBonusTapOnIcon:(id)sender {
    NSURL *url = [[NSURL alloc]initWithString: NSLocalizedString(@"http://www.sebastiaanschool.nl", nil)];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)doTapOnIcon:(id)sender {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    animation.autoreverses = NO;
    animation.repeatCount = 3;
    [self.iconImageView.layer addAnimation:animation forKey:@"360"];
}

- (void)applyTitle:(NSString *)title toButton:(UIButton*)button {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[SBSStyle sebastiaanBlueColor] forState:UIControlStateNormal];
}

- (IBAction)buttonTapped:(id)sender {
    if (sender == self.callButton) {
        NSURL *url = [NSURL URLWithString:@"telprompt://+31555335355"];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [self trackEvent:@"Call button tapped on phone."];
            [[UIApplication sharedApplication] openURL:url];
        } else {
            [self trackEvent:@"Call button tapped on non-phone."];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your device does not support phone calls. Please call 055 53 35 355 with your phone.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
    } else if(sender == self.twitterButton) {
        NSURL *twitterAppUrl = [NSURL URLWithString:@"twitter://user?id=424159127"];
        if([[UIApplication sharedApplication] canOpenURL:twitterAppUrl]) {
            [self trackEvent:@"Twitter button tapped with Twitter App."];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?id=424159127"]];
        } else {
            [self trackEvent:@"Twitter button tapped without Twitter App."];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/KBSebastiaan"]];
        }
    } else if (sender == self.yurlButton) {
        [self trackEvent:@"Yurls button tapped"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sebastiaan.yurls.net"]];
    } else {
        if(sender == self.agendaButton) {
            [self performSegueWithIdentifier:@"agendaSegue" sender:self];
        } else if(sender == self.teamButton) {
            [self performSegueWithIdentifier:@"teamSegue" sender:self];
        } else if(sender == self.newsButton) {
            [self performSegueWithIdentifier:@"newsletterSegue" sender:self];
        } else if(sender == self.bulletinButton) {
            [self performSegueWithIdentifier:@"bulletinSegue" sender:self];
        } else if(sender == self.staffBarButton) {
            UIViewController *vc = [[SBSStaffViewController alloc] init];
            vc.title = NSLocalizedString(@"Staff", nil);
            [self trackEvent:[NSString stringWithFormat:@"%@ button tapped on phone.", vc.title]];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSAssert(NO, @"Unknown button tapped.");
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self trackEvent:[NSString stringWithFormat:@"%@ button tapped on phone.", segue.identifier]];
}

@end
