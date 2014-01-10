//
//  SBSEditNewsLetterViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 10-01-14.
//
//

#import <UIKit/UIKit.h>

#import "SBSNewsLetter.h"
#import "SBSBaseEditViewController.h"

@protocol SBSEditNewsLetterDelegate <NSObject>

-(void)createNewsLetter:(SBSNewsLetter *)newNewsletter;
-(void)updateNewsLetter:(SBSNewsLetter *)updatedNewsletter;
-(void)deleteNewsLetter:(SBSNewsLetter *)deletedNewsletter;

@end

@interface SBSEditNewsLetterViewController : SBSBaseEditViewController

@property (nonatomic, weak) id<SBSEditNewsLetterDelegate> delegate;
@property (nonatomic, strong)SBSNewsLetter * newsletter;

@end
