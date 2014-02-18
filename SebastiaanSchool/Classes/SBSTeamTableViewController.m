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
#import "SBSEditTeamMemberViewController.h"

#import "SBSContactItem.h"

@interface SBSTeamTableViewController ()
@property (nonatomic, strong) NSMutableArray *editedObjects;
@end

@implementation SBSTeamTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRoleChanged:) name:SBSUserRoleDidChangeNotification object:nil];

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
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
	// Do any additional setup after loading the view.
    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateBarButtonItemsAnimated:animated editing:NO];
}

-(void)updateBarButtonItemsAnimated:(BOOL)animated editing:(BOOL)editing {
    NSArray *buttons = nil;

    if ([[SBSSecurity instance] currentUserStaffUser]) {
        if (editing) {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
            @weakify(self);
            doneButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                if (self.editedObjects != nil) {
                    [[self.navigationItem rightBarButtonItems] makeObjectsPerformSelector:@selector(setEnabled:) withObject:@(NO)];
                    @weakify(self);
                    [PFObject saveAllInBackground:self.editedObjects block:^(BOOL succeeded, NSError *error) {
                        @strongify(self);
                        [self updateBarButtonItemsAnimated:YES editing:NO];
                        [self loadObjects];
                        [self setEditing:NO animated:YES];
                    }];
                    self.editedObjects = nil;
                } else {
                    [self updateBarButtonItemsAnimated:YES editing:NO];
                    [self setEditing:NO animated:YES];
                }

                return [RACSignal empty];
            }];
            buttons = @[doneButton];
            
        } else {
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
            @weakify(self);
            addButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                SBSEditTeamMemberViewController *addTeamMemberVC = [[SBSEditTeamMemberViewController alloc]init];
                addTeamMemberVC.delegate = self;
                [self.navigationController pushViewController:addTeamMemberVC animated:YES];

                return [RACSignal empty];
            }];
            UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
            editButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                NSAssert([[SBSSecurity instance] currentUserStaffUser], @"User has to be a staff user");
                [self updateBarButtonItemsAnimated:YES editing:YES];
                [self setEditing:YES animated:YES];

                return [RACSignal empty];
            }];
            buttons = @[editButton, addButton];
        }
    }
    [self.navigationItem setRightBarButtonItems:buttons animated:animated];
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
        if (!IS_IOS_7) {
            cell.selectedBackgroundView = [SBSStyle selectedBackgroundView];
            cell.selectedBackgroundView.frame = cell.bounds;
        }
    }
    
    // Configure the cell
    cell.textLabel.text = contactItem.displayName;
    cell.detailTextLabel.text = contactItem.detailText;
    
    return cell;
}


#pragma mark - Table view data source

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [SBSSecurity instance].currentUserStaffUser;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
     toIndexPath:(NSIndexPath *)toIndexPath {
    if (self.editedObjects == nil) {
        self.editedObjects = [self.objects mutableCopy];
    }
    
    id item = [self.editedObjects objectAtIndex:fromIndexPath.row];
    [self.editedObjects removeObjectAtIndex:fromIndexPath.row];
    [self.editedObjects insertObject:item atIndex:toIndexPath.row];
    
    [self.editedObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SBSContactItem *contact = obj;
        contact.order = @(idx);
    }];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SBSContactItem *contactItem = (SBSContactItem *)[self objectAtIndexPath:indexPath];
        NSString *contactItemName = contactItem.displayName;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat: NSLocalizedString(@"Are you sure you want to delete \"%@\"?", nil), contactItemName] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:nil];
        [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            if (buttonIndex.integerValue == actionSheet.cancelButtonIndex) {
                return;
            }
            // Delete the row from the data source
            SBSContactItem *deletedTeamMember = (SBSContactItem *)[self objectAtIndexPath:self.tableView.indexPathForSelectedRow];
            [self deleteTeamMember:deletedTeamMember];

        }];
        
        [[UIApplication sharedApplication] sendAction:@selector(displayActionSheet:) to:nil from:actionSheet forEvent:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[SBSSecurity instance] currentUserStaffUser]) {
        SBSEditTeamMemberViewController *teamMemberVC = [[SBSEditTeamMemberViewController alloc]init];
        teamMemberVC.delegate = self;
        teamMemberVC.contact = (SBSContactItem *)[self objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:teamMemberVC animated:YES];
        
        return;
    }


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
    if (IS_IOS_7) {
        //The navigation tint color is not propagated by UIAppearance for some reason. So setting it manually.
        mc.navigationBar.tintColor = [UIColor whiteColor];
    }
    
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

#pragma mark - Listen for security role changes

-(void)userRoleChanged:(NSNotification *)notification {
    [self updateBarButtonItemsAnimated:YES editing:NO];
}

@end
