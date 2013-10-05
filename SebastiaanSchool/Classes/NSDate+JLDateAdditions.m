//
//  NSDate+JLDateAdditions.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 01-05-13.
//
//

#import "NSDate+JLDateAdditions.h"

@implementation NSDate (JLDateAdditions)

+ (NSDate *)midnightDate{
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags
                                                                   fromDate:[NSDate date]];
    NSString *stringDate = [NSString stringWithFormat:@"%d/%d/%d", components.day, components.month, components.year];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"dd/MM/yyyy";
    
    return [formatter dateFromString:stringDate];
}

@end
