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
