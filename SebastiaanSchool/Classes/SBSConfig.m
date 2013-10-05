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
