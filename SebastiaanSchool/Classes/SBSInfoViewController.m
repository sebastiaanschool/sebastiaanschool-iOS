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
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }

    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];
    if (IS_IOS_7) {
        self.iconImageView.image = [UIImage imageNamed:@"big-logo"];
    } else {
        self.view.backgroundColor = [SBSStyle sebastiaanBlueColor];
        self.iconImageView.image = [UIImage imageNamed:@"big-logo-white"];
    }
    [self applyTitle:NSLocalizedString(@"Call", nil) andWithImageNamed:@"75-phone" toButton:self.callButton];
    [self applyTitle:NSLocalizedString(@"@KBSebastiaan", nil) andWithImageNamed:@"twitter-bird" toButton:self.twitterButton];
    [self applyTitle:NSLocalizedString(@"Yurl site", nil) andWithImageNamed:@"yurl-logo" toButton:self.yurlButton];
    [self applyTitle:NSLocalizedString(@"Agenda", nil) andWithImageNamed:@"259-list" toButton:self.agendaButton];
    [self applyTitle:NSLocalizedString(@"Team", nil) andWithImageNamed:@"112-group" toButton:self.teamButton];
    [self applyTitle:NSLocalizedString(@"Newsletter", nil) andWithImageNamed:@"162-receipt" toButton:self.newsButton];
    [self applyTitle:NSLocalizedString(@"Bulletin", nil) andWithImageNamed:@"275-broadcast" toButton:self.bulletinButton];
    
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

- (void)applyTitle:(NSString *)title andWithImageNamed:(NSString *)imageName toButton:(UIButton*)button {
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];

    [button setTitle:title forState:UIControlStateNormal];
    
    if (!IS_IOS_7) {
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 5.0f;
        UIImage *whiteImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-white", imageName]];
        [button setImage:whiteImage forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tintColor = [SBSStyle sebastiaanBlueColor];
    } else {
        [button setTitleColor:[SBSStyle sebastiaanBlueColor] forState:UIControlStateNormal];
    }
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
        UIViewController *vc;
        if(sender == self.agendaButton) {
            vc = [[SBSAgendaTableViewController alloc] init];
            vc.title = NSLocalizedString(@"Agenda", nil);
        } else if(sender == self.teamButton) {
            vc = [[SBSTeamTableViewController alloc] init];
            vc.title = NSLocalizedString(@"Team", nil);
        } else if(sender == self.newsButton) {
            vc = [[SBSNewsLetterTableViewController alloc] init];
            vc.title = NSLocalizedString(@"Newsletter", nil);
        } else if(sender == self.bulletinButton) {
            vc = [[SBSBulletinViewController alloc] init];
            vc.title = NSLocalizedString(@"Bulletin", nil);
        } else if(sender == self.staffBarButton) {
            vc = [[SBSStaffViewController alloc] init];
            vc.title = NSLocalizedString(@"Staff", nil);
        } else {
            NSAssert(NO, @"Unknown button tapped.");
        }
        [self trackEvent:[NSString stringWithFormat:@"%@ button tapped on phone.", vc.title]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
