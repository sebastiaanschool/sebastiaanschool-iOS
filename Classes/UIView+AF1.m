// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  UIView+AF1.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 20-08-13.
//
//

#import "UIView+AF1.h"
#import <objc/runtime.h>

static const NSString * kAF1ParallaxDepthKey = @"kAF1ParallaxDepthKey";
static const NSString * kAF1ParallaxMotionEffectGroupKey = @"kAF1ParallaxMotionEffectGroupKey";
@implementation UIView (AF1)

-(void)setParallaxIntensity:(CGFloat)parallaxDepth
{
    if (!IS_IOS_7) {
        return;
    }
    if (self.parallaxIntensity == parallaxDepth)
        return;
    
    objc_setAssociatedObject(self, (__bridge const void *)(kAF1ParallaxDepthKey), @(parallaxDepth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (parallaxDepth == 0.0)
    {
        [self removeMotionEffect:[self af1_parallaxMotionEffectGroup]];
        [self af1_setParallaxMotionEffectGroup:nil];
        return;
    }
    
    UIMotionEffectGroup * parallaxGroup = [self af1_parallaxMotionEffectGroup];
    if (!parallaxGroup)
    {
        parallaxGroup = [[UIMotionEffectGroup alloc] init];
        [self af1_setParallaxMotionEffectGroup:parallaxGroup];
        [self addMotionEffect:parallaxGroup];
    }
    
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    NSArray * motionEffects = @[xAxis, yAxis];
    
    for (UIInterpolatingMotionEffect * motionEffect in motionEffects )
    {
        motionEffect.maximumRelativeValue = @(parallaxDepth);
        motionEffect.minimumRelativeValue = @(-parallaxDepth);
    }
    parallaxGroup.motionEffects = motionEffects;
}

-(CGFloat)parallaxIntensity
{
    NSNumber * val = objc_getAssociatedObject(self, (__bridge const void *)(kAF1ParallaxDepthKey));
    if (!val)
        return 0.0;
    return val.doubleValue;
}

#pragma mark -

-(UIMotionEffectGroup*)af1_parallaxMotionEffectGroup
{
    return objc_getAssociatedObject(self, (__bridge const void *)(kAF1ParallaxMotionEffectGroupKey));
}

-(void)af1_setParallaxMotionEffectGroup:(UIMotionEffectGroup*)group
{
    objc_setAssociatedObject(self, (__bridge const void *)(kAF1ParallaxMotionEffectGroupKey), group, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSAssert( group == objc_getAssociatedObject(self, (__bridge const void *)(kAF1ParallaxMotionEffectGroupKey)), @"set didn't work" );
}

@end
