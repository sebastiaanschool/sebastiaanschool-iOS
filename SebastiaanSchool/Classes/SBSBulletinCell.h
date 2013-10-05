//
//  SBSBulletinCell.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import <UIKit/UIKit.h>
#import "SBSBulletin.h"

@interface SBSBulletinCell : UITableViewCell

@property (nonatomic, readonly) UILabel *bodyLabel;

+ (CGFloat)heightForWidth:(CGFloat)width withItem:(SBSBulletin *)object;

@end
