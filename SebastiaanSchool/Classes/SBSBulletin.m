//
//  SBSBulletin.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSBulletin.h"

@implementation SBSBulletin

@dynamic title, body;

+ (NSString *)parseClassName {
    return @"Bulletin";
}

@end
