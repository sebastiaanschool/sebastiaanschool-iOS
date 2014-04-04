//
//  KIFUITestActor+SBSTestActorAdditions.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 29-03-14.
//
//

#import "KIFUITestActor.h"

@interface KIFUITestActor (SBSTestActorAdditions)

- (BOOL)existsViewWithAccessibilityLabel:(NSString *)label;

@end
