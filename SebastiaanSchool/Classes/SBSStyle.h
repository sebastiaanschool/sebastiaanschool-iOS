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
