// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSInfoViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//
#import "SBSButton.h"

@interface SBSInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet SBSButton *callButton;
@property (weak, nonatomic) IBOutlet SBSButton *agendaButton;
@property (weak, nonatomic) IBOutlet SBSButton *twitterButton;
@property (weak, nonatomic) IBOutlet SBSButton *yurlButton;
@property (weak, nonatomic) IBOutlet SBSButton *teamButton;
@property (weak, nonatomic) IBOutlet SBSButton *newsButton;
@property (weak, nonatomic) IBOutlet SBSButton *bulletinButton;

- (IBAction)buttonTapped:(id)sender;
-(void)updateBarButtonItemAnimated:(BOOL)animated;
@end
