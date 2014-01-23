//
//  SBSNewsLetterViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//

#import "SBSNewsLetterTableViewController.h"
#import "SBSNewsLetterViewController.h"
#import "SBSConfig.h"

#import "SBSNewsLetter.h"

@interface SBSNewsLetterTableViewController ()

@end

@implementation SBSNewsLetterTableViewController

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
        self.parseClassName = [SBSNewsLetter parseClassName];
        
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self trackEvent:[NSString stringWithFormat:@"Loaded VC %@", self.title]];

    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
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
            addButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                SBSEditNewsLetterViewController *editNewsLetterVC = [[SBSEditNewsLetterViewController alloc]init];
                editNewsLetterVC.delegate = self;
                [self.navigationController pushViewController:editNewsLetterVC animated:YES];
                
                return [RACSignal empty];
            }];
            [self.navigationItem setRightBarButtonItem:addButton animated:animated];
        }
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
}

#pragma mark - SBSEditNewsLetterViewController delegates

-(void)createNewsLetter:(SBSNewsLetter *)newNewsLetter {
    @weakify(self);
    [newNewsLetter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while adding newsletter: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)updateNewsLetter:(SBSNewsLetter *)updatedNewsLetter {
    @weakify(self);
    [updatedNewsLetter saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while updating newsletter: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)deleteNewsLetter:(SBSNewsLetter *)deletedNewsLetter {
    @weakify(self);
    [deletedNewsLetter deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        @strongify(self);
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while deleting newsletter: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - Parse

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [SBSNewsLetter query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"publishedAt"];
    
    return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    SBSNewsLetter *newsletter = (SBSNewsLetter *)object;
    static NSString *CellIdentifier = @"newsLetterCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (!IS_IOS_7) {
            cell.selectedBackgroundView = [SBSStyle selectedBackgroundView];
            cell.selectedBackgroundView.frame = cell.bounds;
        }
    }
    
    // Configure the cell
    cell.textLabel.text = [newsletter.name capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Published: %@", nil), [[SBSStyle longStyleDateFormatter] stringFromDate:newsletter.publishedAt]];
    if ([[SBSSecurity instance] currentUserStaffUser]) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBSNewsLetter *newsLetter = (SBSNewsLetter *)[self objectAtIndexPath:indexPath];
    SBSNewsLetterViewController *newsletterViewController = [[SBSNewsLetterViewController alloc]initWithNewsLetter:newsLetter];
    newsletterViewController.title = [newsLetter.name capitalizedString];
    [self.navigationController pushViewController:newsletterViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    SBSEditNewsLetterViewController *newsletterVC = [[SBSEditNewsLetterViewController alloc]init];
    newsletterVC.delegate = self;
    newsletterVC.newsletter = (SBSNewsLetter *)[self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:newsletterVC animated:YES];
}


#pragma mark - Listen for security role changes

-(void)userRoleChanged:(NSNotification *)notification {
    [self updateBarButtonItemAnimated:YES];
    [self loadObjects];
}


@end
