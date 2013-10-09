//
//  NSObject+SBSAnalytics.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 09-10-13.
//
//

#import "NSObject+SBSAnalytics.h"

#import <PFAnalytics.h>
#import <TestFlightSDK/TestFlight.h>

@implementation NSObject (SBSAnalytics)

- (void)trackEvent:(NSString *)name {
    [PFAnalytics trackEvent:name];
    [TestFlight passCheckpoint:name];
}

@end
