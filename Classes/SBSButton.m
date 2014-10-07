// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSButton.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-09-13.
//
//

#import "SBSButton.h"

@implementation SBSButton

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
