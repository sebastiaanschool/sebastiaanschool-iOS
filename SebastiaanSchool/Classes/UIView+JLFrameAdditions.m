//
//  UIView+JLFrameAdditions.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import "UIView+JLFrameAdditions.h"

@implementation UIView (JLFrameAdditions)

- (CGPoint)_origin
{
    return self.frame.origin;
}
- (void)set_origin:(CGPoint)origin
{
    self.frame = (CGRect){ .origin=origin, .size=self.frame.size };
}

- (CGFloat)_x { return self.frame.origin.x; }
- (void)set_x:(CGFloat)x { self.frame = (CGRect){ .origin.x=x, .origin.y=self.frame.origin.y, .size=self.frame.size }; }

- (CGFloat)_y { return self.frame.origin.y; }
- (void)set_y:(CGFloat)y { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=y, .size=self.frame.size }; }

- (CGSize)_size { return self.frame.size; }
- (void)set_size:(CGSize)size { self.frame = (CGRect){ .origin=self.frame.origin, .size=size }; }

- (CGFloat)_width { return self.frame.size.width; }
- (void)set_width:(CGFloat)width { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=width, .size.height=self.frame.size.height }; }

- (CGFloat)_height { return self.frame.size.height; }
- (void)set_height:(CGFloat)height { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=height }; }

- (CGFloat)_left { return self.frame.origin.x; }
- (void)set_left:(CGFloat)left { self.frame = (CGRect){ .origin.x=left, .origin.y=self.frame.origin.y, .size.width=fmaxf(self.frame.origin.x+self.frame.size.width-left,0), .size.height=self.frame.size.height }; }

- (CGFloat)_top { return self.frame.origin.y; }
- (void)set_top:(CGFloat)top { self.frame = (CGRect){ .origin.x=self.frame.origin.x, .origin.y=top, .size.width=self.frame.size.width, .size.height=fmaxf(self.frame.origin.y+self.frame.size.height-top,0) }; }

- (CGFloat)_right { return self.frame.origin.x + self.frame.size.width; }
- (void)set_right:(CGFloat)right
{
    self.frame = (CGRect){ .origin=self.frame.origin, .size.width=fmaxf(right-self.frame.origin.x,0), .size.height=self.frame.size.height };
}

- (CGFloat)_bottom { return self.frame.origin.y + self.frame.size.height; }
- (void)set_bottom:(CGFloat)bottom { self.frame = (CGRect){ .origin=self.frame.origin, .size.width=self.frame.size.width, .size.height=fmaxf(bottom-self.frame.origin.y,0) }; }

-(void) makeRectIntegral { self.frame = CGRectIntegral(self.frame); }

@end
