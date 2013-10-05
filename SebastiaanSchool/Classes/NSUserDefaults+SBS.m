//
//  NSUserDefaults+SBS.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-01-13.
//
//

@implementation NSUserDefaults (SBS)

+(BOOL) enableStaffLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    return [defaults boolForKey:@"enableStaffLogin"];    
}

@end
