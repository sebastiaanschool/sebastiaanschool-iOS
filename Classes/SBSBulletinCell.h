// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSBulletinCell.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import <UIKit/UIKit.h>

#import <TTTAttributedLabel/TTTAttributedLabel.h>

#import "SBSBulletin.h"

@interface SBSBulletinCell : UITableViewCell

@property (nonatomic, readonly) TTTAttributedLabel *bodyLabel;

/**
 Calculates the height for the a `SBSBulletinCell` for a given SBSBulletin object.
 
 This height can typically be returned from for a cell's height.
 
 @param width The available width to base the height calculation on.
 @param object The item to calculate the height for.
 @return The required height to allow proper display of an SBSBulletin in the SBSBulletinCell.
 */
+ (CGFloat)heightForWidth:(CGFloat)width withItem:(SBSBulletin *)object;

@end
