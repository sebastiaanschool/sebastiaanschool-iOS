//
//  SBSSecurity.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 20-01-13.
//
//

extern NSString * const SBSUserRoleDidChangeNotification;


@interface SBSSecurity : NSObject
@property (nonatomic, readonly) BOOL currentUserStaffUser;

+(SBSSecurity *)instance;

-(void)reset;

@end
