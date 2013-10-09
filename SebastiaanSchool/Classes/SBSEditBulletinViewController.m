//
//  SBSEditBulletinViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 22-03-13.
//
//

#import "SBSEditBulletinViewController.h"

@interface SBSEditBulletinViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteButtonPressed:(id)sender;

@end

@implementation SBSEditBulletinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Bulletin", nil);
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
    
    self.titleLabel.text = NSLocalizedString(@"Message", nil);
    self.bodyLabel.text = NSLocalizedString(@"Message content", nil);
    
    [SBSStyle applyStyleToTextView:self.titleTextView];
    self.titleTextView.font = [SBSStyle titleFont];
    [SBSStyle applyStyleToTextView:self.bodyTextView];

    [self updateLayout];
    
    self.titleTextView.text = self.bulletin.title;
    self.bodyTextView.text = self.bulletin.body;
    
    [SBSStyle applyStyleToDeleteButton:self.deleteButton];

    self.titleTextView.inputAccessoryView = self.textViewAccessoryView;
    self.bodyTextView.inputAccessoryView = self.textViewAccessoryView;
}

- (void)setBulletin:(SBSBulletin *)bulletin {
    _bulletin = bulletin;
    
    [self updateLayout];
}

- (void) updateLayout {
    if (self.bulletin == nil) {
        self.deleteButton.hidden = YES;
        self.title = NSLocalizedString(@"Add Bulletin", nil);
    } else {
        self.deleteButton.hidden = NO;
        self.title = NSLocalizedString(@"Edit Bulletin", nil);
        
    }
}

-(void)saveButtonPressed:(id) sender {
    SBSBulletin *bulletin = self.bulletin;
    if (self.bulletin == nil) {
        bulletin = [[SBSBulletin alloc]init];
    }
    
    if (self.titleTextView.text.length !=0) {
        bulletin.title = self.titleTextView.text;
        if (self.bodyTextView.text.length !=0) {
            bulletin.body = self.bodyTextView.text;
        }
        if (self.bulletin == nil) {
            [self.delegate createBulletin:bulletin];
        } else {
            [self.delegate updateBulletin:bulletin];
        }
    }
}

- (void)viewDidUnload {
    [self setTitleTextView:nil];
    [self setBodyTextView:nil];
    [self setTitleLabel:nil];
    [self setBodyLabel:nil];
    [self setDeleteButton:nil];
    [super viewDidUnload];
}
- (IBAction)deleteButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Delete Bulletin?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles: nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].delegate.window.rootViewController.view];
}

#pragma mark - Text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == self.titleTextView) {
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

#pragma mark - Action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.destructiveButtonIndex) {
        return;
    }

    [self.delegate deleteBulletin:self.bulletin];
}
@end
