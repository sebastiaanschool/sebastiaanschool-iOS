//
//  SBSAgendaItem.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSAgendaItem.h"

@implementation SBSAgendaItem

@dynamic name, start, end;

+ (NSString *)parseClassName {
    return @"AgendaItem";
}

@end
