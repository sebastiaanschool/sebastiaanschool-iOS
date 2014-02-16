// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSAddTeamMemberViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 09-02-13.
//
//

#import "SBSContactItem.h"
#import "SBSBaseEditViewController.h"

@protocol SBSAddTeamMemberDelegate <NSObject>

-(void)createTeamMember:(SBSContactItem *)newTeamMember;
-(void)updateTeamMember:(SBSContactItem *)updatedTeamMember;
-(void)deleteTeamMember:(SBSContactItem *)deletedTeamMember;

@end

@interface SBSEditTeamMemberViewController : SBSBaseEditViewController

@property (nonatomic, unsafe_unretained) id<SBSAddTeamMemberDelegate> delegate;
@property (nonatomic, strong)SBSContactItem * contact;

@end
