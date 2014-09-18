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
#import "SBSStyle.h"

@interface SebastiaanSchool_Tests : KIFTestCase

@end

@implementation SebastiaanSchool_Tests

- (void)beforeAll {
    [tester tapViewWithAccessibilityLabel:@"Personeel"];
    
    if ([tester tryFindingViewWithAccessibilityLabel:@"Uitloggen" error:nil]) {
        [tester tapViewWithAccessibilityLabel:@"Uitloggen"];
    }
    
    [tester tapViewWithAccessibilityLabel:@"Inloggen..."];
    
    [tester tapScreenAtPoint:CGPointMake(50, 220)];
    [tester enterTextIntoCurrentFirstResponder:@"jeroen"];
    [tester tapScreenAtPoint:CGPointMake(50, 260)];
    [tester enterTextIntoCurrentFirstResponder:@"jeroen"];
    [tester tapViewWithAccessibilityLabel:@"Inloggen"];
}

- (void)testAddingBulletin
{
    [tester tapViewWithAccessibilityLabel:@"Mededeling"];
    [tester tapViewWithAccessibilityLabel:@"Voeg toe"];

    NSString *bulletinTitle = @"This is a demo";
    NSString *bulletinBody = @"I will now show you how fast I can type with this KIF stuff. Isn't it awesome?";
    NSString *bulletinPublishedDate = [NSString stringWithFormat:@"Gepubliceerd: %@", [[SBSStyle longStyleDateFormatter] stringFromDate: [NSDate date]]];
    [tester enterText:bulletinTitle intoViewWithAccessibilityLabel: @"Message title input textview"];
    [tester enterText:bulletinBody intoViewWithAccessibilityLabel:@"Message body input textview"];

    [tester tapViewWithAccessibilityLabel:@"Bewaar"];
    
    [tester tapViewWithAccessibilityLabel:[NSString stringWithFormat:@"%@, %@, %@", bulletinTitle, bulletinPublishedDate, bulletinBody]];
    [tester tapViewWithAccessibilityLabel:@"Verwijderen"];
    [tester tapViewWithAccessibilityLabel:@"Verwijderen"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:[NSString stringWithFormat:@"%@, %@, %@", bulletinTitle, bulletinPublishedDate, bulletinBody]];
    
    [tester tapViewWithAccessibilityLabel:@"Terug"];
    [tester waitForTimeInterval:1];
}

@end
