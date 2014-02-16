// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSBaseEditViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 21-04-13.
//
//

#import <UIKit/UIKit.h>

@interface SBSBaseEditViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, readonly) UIToolbar * textViewAccessoryView;


@end
