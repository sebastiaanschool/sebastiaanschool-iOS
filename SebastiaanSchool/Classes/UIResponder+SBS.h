// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  NSResponder+SBS.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-10-13.
//
//

@interface UIResponder (SBS)
- (void)trackEvent:(NSString *)name;
@end

@interface UIResponder (SBSChain)
- (void) displayActionSheet:(UIActionSheet *)actionsheet;
@end
