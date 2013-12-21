//
//  SBSEditAgendaViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 21-04-13.
//
//

#import "SBSBaseEditViewController.h"

#import "SBSAgendaItem.h"

@protocol SBSEditAgendaItemDelegate <NSObject>

-(void)createAgendaItem:(SBSAgendaItem *)agendaItem;
-(void)updateAgendaItem:(SBSAgendaItem *)agendaItem;
-(void)deleteAgendaItem:(SBSAgendaItem *)agendaItem;

@end

@interface SBSEditAgendaViewController : SBSBaseEditViewController <UIActionSheetDelegate>

@property (nonatomic, weak) id<SBSEditAgendaItemDelegate> delegate;
@property (nonatomic, strong)SBSAgendaItem * agendaItem;

@end
