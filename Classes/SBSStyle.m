// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSStyle.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//
//

static UIColor * sebastiaanBlueColor;
static NSDateFormatter * longStyleDateFormatter;

static UIFont * titleFont;
static UIFont * subtitleFont;
static UIFont * bodyFont;

@implementation SBSStyle

+ (void)initialize {
    if ([SBSStyle class] == self) {
        sebastiaanBlueColor = [UIColor colorWithRed:49/255.0f green:181/255.0f blue:231/255.0f alpha:1.0];
        
        longStyleDateFormatter = [[NSDateFormatter alloc] init];
        [longStyleDateFormatter setDateStyle:NSDateFormatterLongStyle];
        
        titleFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize] +1.0f];
        subtitleFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        bodyFont = [UIFont systemFontOfSize:[UIFont systemFontSize] +2.0f];
    }
}

+ (UIColor *)sebastiaanBlueColor {
    return sebastiaanBlueColor;
}

+ (NSDateFormatter *)longStyleDateFormatter {
    return longStyleDateFormatter;
}

+ (UIView *)selectedBackgroundView {
    UIView * const newSelectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    newSelectedBackgroundView.backgroundColor = [SBSStyle sebastiaanBlueColor];
    newSelectedBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    return newSelectedBackgroundView;
}

+ (UIFont *)titleFont {
    return titleFont;
}

+ (UIFont *)subtitleFont {
    return subtitleFont;
}

+ (UIFont *)bodyFont {
    return bodyFont;
}

+ (CGFloat)phoneWidth {
    return 320.0f;
}

+ (CGFloat)standardMargin {
    return 15.0f;
}

+ (void)applyStyleToTextView:(UITextView *)textView {
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.font = [SBSStyle bodyFont];
}

+ (void)applyStyleToDeleteButton:(UIButton *)deleteButton {
    [deleteButton setBackgroundImage:[[UIImage imageNamed:@"redButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    deleteButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
}

@end
