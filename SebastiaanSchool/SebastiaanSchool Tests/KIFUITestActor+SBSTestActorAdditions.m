//
//  KIFUITestActor+SBSTestActorAdditions.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 29-03-14.
//
//

#import <KIF.h>
#import <NSError-KIFAdditions.h>
#import <UIApplication-KIFAdditions.h>
#import <UIAccessibilityElement-KIFAdditions.h>

#import "KIFUITestActor+SBSTestActorAdditions.h"


@implementation KIFUITestActor (SBSTestActorAdditions)

- (BOOL)existsViewWithAccessibilityLabel:(NSString *)label
{
    UIView *view = nil;
    UIAccessibilityElement *element = nil;
    return [self existsAccessibilityElement:&element view:&view withLabel:label value:nil traits:UIAccessibilityTraitNone tappable:YES];
}

- (BOOL)existsAccessibilityElement:(UIAccessibilityElement **)element view:(out UIView **)view withLabel:(NSString *)label value:(NSString *)value traits:(UIAccessibilityTraits)traits tappable:(BOOL)mustBeTappable
{
    KIFTestStepResult (^executionBlock)(NSError **) = ^(NSError **error) {
        return [UIAccessibilityElement accessibilityElement:element view:view withLabel:label value:value traits:traits tappable:mustBeTappable error:error] ? KIFTestStepResultSuccess : KIFTestStepResultWait;
    };
    
    NSDate *startDate = [NSDate date];
    KIFTestStepResult result;
    NSError *error = nil;
    NSTimeInterval timeout = 10.0;
    
    while ((result = executionBlock(&error)) == KIFTestStepResultWait && -[startDate timeIntervalSinceNow] < timeout) {
        CFRunLoopRunInMode([[UIApplication sharedApplication] currentRunLoopMode] ?: kCFRunLoopDefaultMode, 0.1, false);
    }
    
    if (result == KIFTestStepResultWait) {
        error = [NSError KIFErrorWithUnderlyingError:error format:@"The step timed out after %.2f seconds: %@", timeout, error.localizedDescription];
        result = KIFTestStepResultFailure;
    }
    
    return (result == KIFTestStepResultSuccess) ? YES : NO;
}
@end
