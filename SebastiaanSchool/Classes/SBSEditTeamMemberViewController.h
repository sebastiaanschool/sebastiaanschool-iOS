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

@interface SBSEditTeamMemberViewController : SBSBaseEditViewController <UIActionSheetDelegate>

@property (nonatomic, unsafe_unretained) id<SBSAddTeamMemberDelegate> delegate;
@property (nonatomic, strong)SBSContactItem * contact;

@end
