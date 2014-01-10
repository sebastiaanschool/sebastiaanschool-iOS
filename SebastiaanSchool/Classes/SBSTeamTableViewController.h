//
//  SBSContactViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//

#import <MessageUI/MessageUI.h>

#import "SBSEditTeamMemberViewController.h"

@interface SBSTeamTableViewController : PFQueryTableViewController <MFMailComposeViewControllerDelegate, SBSAddTeamMemberDelegate>

@end
