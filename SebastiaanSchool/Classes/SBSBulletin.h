//
//  SBSBulletin.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/Parse.h>

@interface SBSBulletin : PFObject<PFSubclassing>

@property (retain) NSString *title;
@property (retain) NSString *body;

@end
