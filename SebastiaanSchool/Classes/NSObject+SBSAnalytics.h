//
//  NSObject+SBSAnalytics.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 09-10-13.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (SBSAnalytics)

- (void)trackEvent:(NSString *)name;

@end
