// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
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
}

@end
