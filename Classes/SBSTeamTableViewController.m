// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSContactViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 12-01-13.
//
//

#import "SBSTeamTableViewController.h"

#import "SBSContactItem.h"

@interface SBSTeamTableViewController ()
@end

@implementation SBSTeamTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = [SBSContactItem parseClassName];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"displayName";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = [SBSContactItem parseClassName];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"displayName";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        self.objectsPerPage = 5;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.title = NSLocalizedString(@"Team", nil);
}

#pragma mark - Parse

- (PFQuery *)queryForTable {
    PFQuery *query = [SBSContactItem query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"order"];
    
    return query;
}

#pragma mark - SBSAddTeamMemberDelegate implementation

-(void)createTeamMember:(SBSContactItem *)newTeamMember {
    @weakify(self);
    [newTeamMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while adding bulletin: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)updateTeamMember:(SBSContactItem *)updatedTeamMember {
    @weakify(self);
    [updatedTeamMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while updating team member: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)deleteTeamMember:(SBSContactItem *)deletedTeamMember {
    @weakify(self);
    [deletedTeamMember deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while deleting team member: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}


// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    SBSContactItem *contactItem = (SBSContactItem *)object;
    static NSString *CellIdentifier = @"contactCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = contactItem.displayName;
    cell.detailTextLabel.text = contactItem.detailText;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SBSContactItem *selectedContactItem = (SBSContactItem *)[self objectAtIndexPath:indexPath];
    
    NSString *displayName = selectedContactItem.displayName;
    NSString *emailRecipient = selectedContactItem.email;

    if ([emailRecipient length] ==0) {
        NSString *title = NSLocalizedString(@"Unknown email addres", nil);
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"No email address of %@ on file.", nil),displayName ];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (![MFMailComposeViewController canSendMail]) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:emailRecipient];
        
        NSString *title = NSLocalizedString(@"Your device can not send email", nil);
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"The email address %@ of %@ has been copied to the pasteboard.", nil), emailRecipient, displayName ];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }

    
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"Dear %@,\n\n", nil), displayName];
    // To address
    NSArray *toRecipents = @[emailRecipient];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    //The navigation tint color is not propagated by UIAppearance for some reason. So setting it manually.
    mc.navigationBar.tintColor = [UIColor whiteColor];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            DLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            DLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            DLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            ALog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
