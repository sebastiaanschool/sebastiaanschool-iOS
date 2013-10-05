//
//  SBSConfig.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 29-09-13.
//
//

#import <Parse/Parse.h>


extern NSString * const SBSNewsletterDiscoveryBaseUrl;
extern NSString * const SBSNewsletterDiscoveryPageUrl;
extern NSString * const SBSNewsletterDiscoveryTitleXpath;
extern NSString * const SBSNewsletterDiscoveryUrlXpath;

@interface SBSConfig : PFObject<PFSubclassing>

@property (retain) NSString *key;
@property (retain) NSString *value;

@end
