//
//  SBSButton.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-09-13.
//
//

#import "SBSButton.h"

@implementation SBSButton

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!IS_IOS_7) {
        if (highlighted) {
            [self setBackgroundColor:[UIColor lightTextColor]];
        } else {
            [self setBackgroundColor:[UIColor whiteColor]];
        }
        
    }

}

- (void)layoutSubviews
{
    // Allow default layout, then adjust image and label positions
    [super layoutSubviews];
    
    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];
    
    imageView.center  = CGPointMake(self._width / 2.0, self._height / 3.0);
    label.center = CGPointMake(self._width / 2.0, self._height * 3.0 / 4.0);
    
    label.frame = CGRectIntegral(label.frame);
    imageView.frame = CGRectIntegral(imageView.frame);
    
}

@end
