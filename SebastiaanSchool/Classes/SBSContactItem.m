// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSContactItem.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 24-03-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSContactItem.h"

@implementation SBSContactItem

@dynamic displayName, detailText, email, order;

+ (NSString *)parseClassName {
    return @"ContactItem";
}

@end
