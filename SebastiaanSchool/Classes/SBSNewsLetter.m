//
//  SBSNewsLetter.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSNewsLetter.h"

@implementation SBSNewsLetter

@dynamic name, url, publishedAt;

+ (NSString *)parseClassName {
    return @"NewsLetter";
}

@end
