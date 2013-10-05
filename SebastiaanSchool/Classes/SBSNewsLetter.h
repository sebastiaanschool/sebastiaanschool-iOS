//
//  SBSNewsLetter.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/Parse.h>

@interface SBSNewsLetter : PFObject<PFSubclassing>

@property (retain) NSString *name;
@property (retain) NSString *url;
@property (retain) NSDate *publishedAt;

@end
