// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSAgendaTableViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 18-01-13.
//
//

#import <EventKit/EventKit.h>

#import "SBSAgendaTableViewController.h"

#import "SBSAgendaItem.h"

@interface SBSAgendaTableViewController ()
@property (nonatomic, strong)EKEventStore *eventStore;
@end

@implementation SBSAgendaTableViewController

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
        self.parseClassName = [SBSAgendaItem parseClassName];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
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

    self.eventStore = [[EKEventStore alloc]init];
	// Do any additional setup after loading the view.
    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBarButtonItemAnimated:animated];
}

-(void)updateBarButtonItemAnimated:(BOOL)animated {
    if ([[SBSSecurity instance] currentUserStaffUser]) {
        if (self.navigationItem.rightBarButtonItem == nil) {
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
            @weakify(self);
            addButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                SBSEditAgendaViewController *editAgendaVC = [[SBSEditAgendaViewController alloc]init];
                editAgendaVC.delegate = self;
                [self.navigationController pushViewController:editAgendaVC animated:YES];

                return [RACSignal empty];
            }];
            [self.navigationItem setRightBarButtonItem:addButton animated:animated];
        }
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
}

#pragma mark - Parse

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [SBSAgendaItem query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"start"];
    
    return query;
}

#pragma mark - SBSEditAgendaViewController delegates

-(void)createAgendaItem:(SBSAgendaItem *)agendaItem {
    @weakify(self);
    [agendaItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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

-(void)updateAgendaItem:(SBSAgendaItem *)agendaItem {
    @weakify(self);
    [agendaItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while updating bulletin: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)deleteAgendaItem:(SBSAgendaItem *)agendaItem {
    @weakify(self);
    [agendaItem deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while deleting bulletin: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    SBSAgendaItem * agendaItem = (SBSAgendaItem *)object;
    static NSString *CellIdentifier = @"agendaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        if (!IS_IOS_7) {
            cell.selectedBackgroundView = [SBSStyle selectedBackgroundView];
            cell.selectedBackgroundView.frame = cell.bounds;
        }
    }
    
    // Configure the cell
    cell.textLabel.text = agendaItem.name;
    NSDate *startDate = agendaItem.start;
    NSDate *endDate = agendaItem.end;
    
    if (startDate != nil && endDate != nil && [startDate compare:endDate] == NSOrderedAscending) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                     [[SBSStyle longStyleDateFormatter] stringFromDate:startDate],
                                     [[SBSStyle longStyleDateFormatter] stringFromDate:endDate]];
    } else if (startDate != nil) {
        cell.detailTextLabel.text = [[SBSStyle longStyleDateFormatter] stringFromDate:startDate];
    } else {
        DLog(@"Missing start and end on event.");
    }
    return cell;
}


#pragma mark - Table view data source
#pragma mark - Table view data source

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [SBSSecurity instance].currentUserStaffUser;
}

//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SBSAgendaItem *agendaItem = (SBSAgendaItem *)[self objectAtIndexPath:indexPath];
        NSString *agendaItemName = agendaItem.name;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat: NSLocalizedString(@"Are you sure you want to delete \"%@\"?", nil), agendaItemName] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete", nil) otherButtonTitles:nil];
        
        [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            if (buttonIndex.integerValue == actionSheet.cancelButtonIndex) {
                return;
            }
            SBSAgendaItem *agendaItem = (SBSAgendaItem *)[self objectAtIndexPath:self.tableView.indexPathForSelectedRow];
            if ([[SBSSecurity instance] currentUserStaffUser]) {
                // Delete the row from the data source
                [self deleteAgendaItem:agendaItem];
            }
        }];
        
        [[UIApplication sharedApplication] sendAction:@selector(displayActionSheet:) to:nil from:actionSheet forEvent:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SBSSecurity instance].currentUserStaffUser) {
        SBSEditAgendaViewController *agendaItemVC = [[SBSEditAgendaViewController alloc]init];
        agendaItemVC.delegate = self;
        agendaItemVC.agendaItem = (SBSAgendaItem *)[self objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:agendaItemVC animated:YES];
    } else {
        SBSAgendaItem *agendaItem = (SBSAgendaItem *)[self objectAtIndexPath:indexPath];
        NSString *agendaItemName = agendaItem.name;
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat: NSLocalizedString(@"Add \"%@\" to your default calendar?", nil), agendaItemName] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Add to calendar", nil), nil];
        
        [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

            if (buttonIndex.integerValue == actionSheet.cancelButtonIndex) {
                return;
            }
            SBSAgendaItem *agendaItem = (SBSAgendaItem *)[self objectAtIndexPath:self.tableView.indexPathForSelectedRow];
            NSString *agendaItemName = agendaItem.name;
            NSDate *agendaItemStartDate = agendaItem.start;
            NSDate *agendaItemEndDate = agendaItem.end;
            
            EKEvent *event=[EKEvent eventWithEventStore:self.eventStore];
            event.allDay = YES;
            event.title=agendaItemName;
            event.startDate=agendaItemStartDate;
            event.endDate=agendaItemEndDate;
            [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
            
            
            if([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
                @weakify(self);
                [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                    @strongify(self);
                    if (granted) {
                        NSError *error;
                        [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                    }
                }];
            } else {
                NSError *error;
                [self.eventStore saveEvent:event span:EKSpanThisEvent error:&error];
            }
        }];

        [[UIApplication sharedApplication] sendAction:@selector(displayActionSheet:) to:nil from:actionSheet forEvent:nil];
    }
}

#pragma mark - Listen for security role changes

-(void)userRoleChanged:(NSNotification *)notification {
    [self updateBarButtonItemAnimated:YES];
}

@end
