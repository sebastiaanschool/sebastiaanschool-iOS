// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  UIView+JLFrameAdditions.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (JLFrameAdditions)

@property (nonatomic, assign) CGPoint _origin;
@property (nonatomic, assign) CGSize _size;
@property (nonatomic, assign) CGFloat _x, _y, _width, _height; // normal rect properties
@property (nonatomic, assign) CGFloat _left, _top, _right, _bottom; // these will stretch the rect

-(void) makeRectIntegral;
@end
