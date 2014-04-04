// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SebastiaanSchool_Tests.m
//  SebastiaanSchool Tests
//
//  Created by Jeroen Leenarts on 21-10-13.
//
//

#import <XCTest/XCTest.h>
#import <OCMock.h>

#import <KIF.h>

#import "KIFUITestActor+SBSTestActorAdditions.h"

#import "SBSConfig.h"
#import "SBSStyle.h"

@interface SebastiaanSchool_Tests : KIFTestCase

@end

@implementation SebastiaanSchool_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    [tester tapViewWithAccessibilityLabel:@"Staff"];
    
    if ([tester existsViewWithAccessibilityLabel:@"Sign out"]) {
        [tester tapViewWithAccessibilityLabel:@"Sign out"];
    }
    
    [tester tapViewWithAccessibilityLabel:@"Sign in..."];
    
    [tester tapScreenAtPoint:CGPointMake(50, 220)];
    [tester enterTextIntoCurrentFirstResponder:@"jeroen"];
    [tester tapScreenAtPoint:CGPointMake(50, 260)];
    [tester enterTextIntoCurrentFirstResponder:@"jeroen"];
    [tester tapViewWithAccessibilityLabel:@"Log in"];

    [tester tapViewWithAccessibilityLabel:@"Bulletin"];
    [tester tapViewWithAccessibilityLabel:@"Add"];

    NSString *bulletinTitle = @"This is a demo";
    NSString *bulletinBody = @"I will now show you how fast I can type with this KIF stuff. Isn't it awesome? ................. :)";
    NSString *bulletinPublishedDate = [NSString stringWithFormat:@"Published: %@", [[SBSStyle longStyleDateFormatter] stringFromDate: [NSDate date]]];
    [tester enterText:bulletinTitle intoViewWithAccessibilityLabel: @"Message title input textview"];
    [tester enterText:bulletinBody intoViewWithAccessibilityLabel:@"Message body input textview"];

    [tester tapViewWithAccessibilityLabel:@"Save"];
    
    [tester tapViewWithAccessibilityLabel:[NSString stringWithFormat:@"%@, %@, %@", bulletinTitle, bulletinPublishedDate, bulletinBody]];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    [tester tapViewWithAccessibilityLabel:@"Delete"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[NSString stringWithFormat:@"%@, %@, %@", bulletinTitle, bulletinPublishedDate, bulletinBody]];
    
//    [tester waitForViewWithAccessibilityLabel:@"Test push"];
//    [tester waitForTimeInterval:1];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester waitForTimeInterval:1];
}

@end
