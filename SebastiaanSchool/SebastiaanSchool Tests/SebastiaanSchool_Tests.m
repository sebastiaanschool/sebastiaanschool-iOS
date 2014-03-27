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

#import "SBSConfig.h"

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
    id mock = [OCMockObject mockForClass:[SBSConfig class]];
#warning XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    [mock verify];
    
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];
    
    [tester tapViewWithAccessibilityLabel:@"Agenda"];
    [tester waitForViewWithAccessibilityLabel:@"Agenda"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];
    
    [tester tapViewWithAccessibilityLabel:@"Team"];
    [tester waitForViewWithAccessibilityLabel:@"Team"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];

    [tester tapViewWithAccessibilityLabel:@"Call"];
    [tester waitForTappableViewWithAccessibilityLabel:@"OK"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];

    [tester tapViewWithAccessibilityLabel:@"Newsletter"];
    [tester waitForViewWithAccessibilityLabel:@"Newsletter"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];
    
    [tester tapViewWithAccessibilityLabel:@"Bulletin"];
    [tester waitForViewWithAccessibilityLabel:@"Bulletin"];
    [tester tapViewWithAccessibilityLabel:@"Back"];
    [tester waitForViewWithAccessibilityLabel:@"Seb@stiaan"];
    

}

@end
