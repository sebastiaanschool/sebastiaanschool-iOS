// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSEditNewsLetterViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 10-01-14.
//
//

#import "SBSEditNewsLetterViewController.h"

@interface SBSEditNewsLetterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonPressed:(id)sender;

@end

@implementation SBSEditNewsLetterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Newsletter", nil);
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.nameTextView.text = self.newsletter.name;
    self.urlTextView.text = self.newsletter.url;

    RACSignal *formValid = [RACSignal
                            combineLatest:@[
                                            self.nameTextView.rac_textSignal,
                                            self.urlTextView.rac_textSignal
                                            ]
                            reduce:^(NSString * title, NSString * url) {
                                return @(title.length > 0 && [url isValidURL]);
                            }];

    @weakify(self);
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:nil action:nil];
    rightBarButtonItem.rac_command = [[RACCommand alloc] initWithEnabled:formValid signalBlock:^RACSignal *(id input) {
        @strongify(self);
        SBSNewsLetter *newsletter = self.newsletter;
        if (self.newsletter == nil) {
            newsletter = [[SBSNewsLetter alloc]init];
        }
        
        if (self.nameTextView.text.length !=0) {
            newsletter.name = self.nameTextView.text;
            if (self.urlTextView.text.length !=0) {
                newsletter.url = self.urlTextView.text;
            } else {
                newsletter.url = nil;
            }
            if (self.newsletter == nil) {
                [self.delegate createNewsLetter:newsletter];
            } else {
                [self.delegate updateNewsLetter:newsletter];
            }
        }

        return [RACSignal empty];
    }];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    self.nameLabel.text = NSLocalizedString(@"Newsletter name", nil);
    self.urlLabel.text = NSLocalizedString(@"Newsletter URL", nil);
    
    [SBSStyle applyStyleToTextView:self.nameTextView];
    self.nameTextView.font = [SBSStyle titleFont];
    [SBSStyle applyStyleToTextView:self.urlTextView];

    [self updateLayout];
    
    [SBSStyle applyStyleToDeleteButton:self.deleteButton];

    self.nameTextView.inputAccessoryView = self.textViewAccessoryView;
    self.urlTextView.inputAccessoryView = self.textViewAccessoryView;
}

- (void)setNewsletter:(SBSNewsLetter *)newsletter {
    _newsletter = newsletter;
    
    [self updateLayout];
}

- (void) updateLayout {
    if (self.newsletter == nil) {
        self.deleteButton.hidden = YES;
        self.title = NSLocalizedString(@"Add Newsletter", nil);
    } else {
        self.deleteButton.hidden = NO;
        self.title = NSLocalizedString(@"Edit Newsletter", nil);
        
    }
}

- (void)viewDidUnload {
    [self setNameTextView:nil];
    [self setUrlTextView:nil];
    [self setNameLabel:nil];
    [self setUrlLabel:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}
- (IBAction)deleteButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Delete Newsletter?", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles: nil];
    
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        if (buttonIndex.integerValue != actionSheet.destructiveButtonIndex) {
            return;
        }
        
        [self.delegate deleteNewsLetter:self.newsletter];
    }];

    [self displayActionSheet:actionSheet];
}

#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.nameTextView) {
        const CGFloat availableWidth = [SBSStyle phoneWidth] - [SBSStyle standardMargin] *2;
        
        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];

        CGSize size;
        if (IS_IOS_7) {
            size = [newText sizeWithAttributes:@{NSFontAttributeName: [SBSStyle titleFont]}];
        } else {
            size = [newText sizeWithFont:[SBSStyle titleFont]];
        }
        BOOL result = availableWidth >= size.width;
        return result;
    }
    
    return YES;
}

@end
