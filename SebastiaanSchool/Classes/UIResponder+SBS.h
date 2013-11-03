//
//  NSResponder+SBS.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-10-13.
//
//

@interface UIResponder (SBS)
- (void)trackEvent:(NSString *)name;
- (void) displayActionSheet:(UIActionSheet *)actionsheet;
@end
