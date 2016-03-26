// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
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
    NSUInteger flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags
                                                                   fromDate:[NSDate date]];
    NSString *stringDate = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)components.day, (long)components.month, (long)components.year];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    formatter.dateFormat = @"dd/MM/yyyy";
    
    return [formatter dateFromString:stringDate];
}

@end
