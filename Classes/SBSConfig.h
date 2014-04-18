// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSConfig.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 29-09-13.
//
//

#import <Parse.h>


extern NSString * const SBSNewsletterDiscoveryBaseUrl;
extern NSString * const SBSNewsletterDiscoveryPageUrl;
extern NSString * const SBSNewsletterDiscoveryTitleXpath;
extern NSString * const SBSNewsletterDiscoveryUrlXpath;

@interface SBSConfig : PFObject<PFSubclassing>

@property (retain) NSString *key;
@property (retain) NSString *value;

@end
