//
//  UIView+AF1.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 20-08-13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (AF1)
// Positive values make the view appear to be above the surface
// Negative values are below.
// The unit is in points
@property (nonatomic) CGFloat parallaxIntensity;
@end
