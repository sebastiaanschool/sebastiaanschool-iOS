//
//  SBSEditAgendaViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 21-04-13.
//
//

#import "SBSEditAgendaViewController.h"

#import "NSDate+JLDateAdditions.h"

@interface SBSEditAgendaViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *startDateTextView;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *endDateTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteButtonPressed:(id)sender;

@end

@implementation SBSEditAgendaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Agenda Item", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        SBSAgendaItem *agendaItem = self.agendaItem;
        if (self.agendaItem == nil) {
            agendaItem = [[SBSAgendaItem alloc]init];
        }
        
        if (self.nameTextView.text.length !=0 && self.startDateTextView.text.length != 0 && self.endDateTextView.text.length != 0) {
            agendaItem.name = self.nameTextView.text;
            agendaItem.start = [(UIDatePicker *)self.startDateTextView.inputView date];
            agendaItem.end = [(UIDatePicker *)self.endDateTextView.inputView date];
            if (self.agendaItem == nil) {
                [self.delegate createAgendaItem:agendaItem];
            } else {
                [self.delegate updateAgendaItem:agendaItem];
            }
        }
        
        return [RACSignal empty];
    }];
    
    self.nameLabel.text = NSLocalizedString(@"Name", nil);
    self.startDateLabel.text = NSLocalizedString(@"Start", nil);
    self.endDateLabel.text = NSLocalizedString(@"End", nil);
    
    [SBSStyle applyStyleToTextView:self.nameTextView];
    [SBSStyle applyStyleToTextView:self.startDateTextView];
    [SBSStyle applyStyleToTextView:self.endDateTextView];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.nameTextView.text = self.agendaItem.name;
    self.startDateTextView.text = [dateFormatter stringFromDate:self.agendaItem.start];
    self.endDateTextView.text = [dateFormatter stringFromDate:self.agendaItem.end];
    
    UIDatePicker *startPicker = [[UIDatePicker alloc] init];
    startPicker.datePickerMode = UIDatePickerModeDate;
    startPicker.date = (self.agendaItem.start != nil)?self.agendaItem.start:[NSDate midnightDate];
    [startPicker addTarget:self action:@selector(startDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    self.startDateTextView.inputView = startPicker;
    [self startDatePickerChanged:startPicker];

    
    UIDatePicker *endPicker = [[UIDatePicker alloc] init];
    endPicker.datePickerMode = UIDatePickerModeDate;
    endPicker.date = (self.agendaItem.end != nil)?self.agendaItem.end:[NSDate midnightDate];
    [endPicker addTarget:self action:@selector(endDatePickerChanged:) forControlEvents:UIControlEventValueChanged];
    self.endDateTextView.inputView = endPicker;
    [self endDatePickerChanged:endPicker];

   
    [SBSStyle applyStyleToDeleteButton:self.deleteButton];
    
    [self updateLayout];
    
    self.nameTextView.inputAccessoryView = self.textViewAccessoryView;
    self.startDateTextView.inputAccessoryView = self.textViewAccessoryView;
    self.endDateTextView.inputAccessoryView = self.textViewAccessoryView;
}

- (void)setAgendaItem:(SBSAgendaItem *)agendaItem {
    _agendaItem = agendaItem;
    
    [self updateLayout];
}

- (void) updateLayout {
    if (self.agendaItem == nil) {
        self.deleteButton.hidden = YES;
        self.title = NSLocalizedString(@"Add Agenda Item", nil);
    } else {
        self.deleteButton.hidden = NO;
        self.title = NSLocalizedString(@"Edit Agenda Item", nil);
        
    }
}

- (void)viewDidUnload {
    [self setNameTextView:nil];
    [self setStartDateTextView:nil];
    [self setEndDateTextView:nil];
    [self setNameLabel:nil];
    [self setStartDateLabel:nil];
    [self setEndDateLabel:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}

- (IBAction)deleteButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Delete Agenda Item?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles: nil];
    
    [self displayActionSheet:actionSheet];
}

- (void)startDatePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];

    NSDate *newStartDate = [(UIDatePicker *)self.startDateTextView.inputView date];
    self.agendaItem.start = newStartDate;
    
    self.startDateTextView.text = [dateFormatter stringFromDate:newStartDate];
}

- (void)endDatePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];

    NSDate *newEndDate = [(UIDatePicker *)self.endDateTextView.inputView date];
    self.agendaItem.end = newEndDate;
    
    self.endDateTextView.text = [dateFormatter stringFromDate:[(UIDatePicker *)self.endDateTextView.inputView date]];
}

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.destructiveButtonIndex) {
        return;
    }
    
    [self.delegate deleteAgendaItem:self.agendaItem];
}
@end
