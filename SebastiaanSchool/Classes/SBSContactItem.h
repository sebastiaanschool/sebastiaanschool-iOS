//
//  SBSContactItem.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/Parse.h>

@interface SBSContactItem : PFObject<PFSubclassing>

@property (retain) NSString *displayName;
@property (retain) NSString *detailText;
@property (retain) NSString *email;
@property (retain) NSNumber *order;

@end
