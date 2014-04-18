// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSStyle.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//
//

@interface SBSStyle : NSObject

+ (UIColor *)sebastiaanBlueColor;
+ (NSDateFormatter *)longStyleDateFormatter;
+ (UIView *)selectedBackgroundView;

+ (UIFont *)titleFont;
+ (UIFont *)subtitleFont;
+ (UIFont *)bodyFont;

+ (CGFloat)phoneWidth;
+ (CGFloat)standardMargin;

+ (void)applyStyleToTextView:(UITextView *)textView;

+ (void)applyStyleToDeleteButton:(UIButton *)deleteButton;

@end
