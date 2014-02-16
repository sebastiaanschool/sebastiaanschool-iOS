// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSConfig.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 29-09-13.
//
//

#import <Parse/PFObject+Subclass.h>
#import "SBSConfig.h"

NSString * const SBSNewsletterDiscoveryBaseUrl = @"newsletterDiscoveryBaseUrl";
NSString * const SBSNewsletterDiscoveryPageUrl = @"newsletterDiscoveryPageUrl";
NSString * const SBSNewsletterDiscoveryTitleXpath = @"newsletterDiscoveryTitleXpath";
NSString * const SBSNewsletterDiscoveryUrlXpath = @"newsletterDiscoveryUrlXpath";

@implementation SBSConfig

@dynamic key;
@dynamic value;

+ (NSString *)parseClassName {
    return @"config";
}
@end
