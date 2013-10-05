//
//  SBSAgendaItem.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/Parse.h>

@interface SBSAgendaItem : PFObject<PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSDate *start;
@property (retain) NSDate *end;

@end
