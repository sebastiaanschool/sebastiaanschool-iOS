//
//  NSResponder+SBS.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-10-13.
//
//

#import "UIResponder+SBS.h"

@implementation UIResponder (SBS)

- (void) displayActionSheet:(UIActionSheet *)actionsheet {
    if (DEBUG_LOGGING) {
        NSLog(@"UIResponder forward %@ -> %@", self.class, [self nextResponder].class);
    }
    [[self nextResponder] displayActionSheet:actionsheet];
}

- (void)trackEvent:(NSString *)name {
    [PFAnalytics trackEvent:name];
    [TestFlight passCheckpoint:name];
}

@end
