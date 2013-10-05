//
//  SBSNewsLetterViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//
//

#import "SBSNewsLetter.h"

@interface SBSNewsLetterViewController : UIViewController <UIWebViewDelegate>

- (id)initWithNewsLetter:(SBSNewsLetter *)newsLetter;

@end
