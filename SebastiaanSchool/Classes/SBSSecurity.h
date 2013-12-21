//
//  SBSSecurity.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 20-01-13.
//
//

extern NSString * const SBSUserRoleDidChangeNotification;


@interface SBSSecurity : NSObject
/**
 *  Determines if the user is a staff user or not. If needed it will contact the Parse backend, when the Parse back-end needs to be contacted, this message will return false.
 *  @warning Please be aware that you should also listen to the SBSUserRoleDidChangeNotification notification. When the back-end is contacted this call will result in a notification at a later moment after this message has returned false.
 */
@property (nonatomic, readonly) BOOL currentUserStaffUser;

/**
 *  The shared SBSSecurity object.
 *
 *  @return The shared instance.
 */
+(instancetype)instance;

-(void)reset;

@end
