// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  NSUserDefaults+SBS.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 17-01-13.
//
//

@interface NSUserDefaults (SBS)
/** Preference value displayed in the App configuration section of the Settings.app. This value controls wether or not staff related UI elements should be displayed to the user. */
+(BOOL) enableStaffLogin;

@end
