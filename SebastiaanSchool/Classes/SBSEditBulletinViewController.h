// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSEditBulletinViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import <UIKit/UIKit.h>

#import "SBSBulletin.h"
#import "SBSBaseEditViewController.h"

@protocol SBSEditBulletinDelegate <NSObject>

-(void)createBulletin:(SBSBulletin *)newBulletin;
-(void)updateBulletin:(SBSBulletin *)updatedBulletin;
-(void)deleteBulletin:(SBSBulletin *)deletedBulletin;

@end

@interface SBSEditBulletinViewController : SBSBaseEditViewController

@property (nonatomic, weak) id<SBSEditBulletinDelegate> delegate;
@property (nonatomic, strong)SBSBulletin * bulletin;

@end
