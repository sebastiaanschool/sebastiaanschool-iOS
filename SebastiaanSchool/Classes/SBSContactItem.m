//
//  SBSContactItem.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSContactItem.h"

@implementation SBSContactItem

@dynamic displayName, detailText, email, order;

+ (NSString *)parseClassName {
    return @"ContactItem";
}

@end
