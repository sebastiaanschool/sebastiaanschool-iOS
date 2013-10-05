#import "SBSBulletinViewController.h"
#import "SBSEditBulletinViewController.h"
#import "SBSBulletinCell.h"

#import "SBSBulletin.h"

@implementation SBSBulletinViewController

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
        self.parseClassName = [SBSBulletin parseClassName];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"title";
        
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
    if (IS_IOS_7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Loaded VC %@", self.title]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBarButtonItemAnimated:animated];
}

-(void)updateBarButtonItemAnimated:(BOOL)animated {
    if ([[SBSSecurity instance] currentUserStaffUser]) {
        if (self.navigationItem.rightBarButtonItem == nil) {
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBulletinButtonPressed:)];
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
    PFQuery *query = [SBSBulletin query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (void)addBulletinButtonPressed:(id)sender {
    SBSEditBulletinViewController *editBuletinVC = [[SBSEditBulletinViewController alloc]init];
    editBuletinVC.delegate = self;
    [self.navigationController pushViewController:editBuletinVC animated:YES];
}

#pragma mark - SBSAddBulletinViewController delegates

-(void)createBulletin:(PFObject *)newBulletin {
    [newBulletin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while adding bulletin: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)updateBulletin:(PFObject *)updatedBulletin {
    [updatedBulletin saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //Do a big reload since the framework VC doesn't support nice view insertions and removal.
            [self loadObjects];
        } else {
            ULog(@"Error while updating bulletin: %@", error);
        }
    }];
    
    [self.navigationController popToViewController:self animated:YES];
}

-(void)deleteBulletin:(PFObject *)deletedBulletin {
    [deletedBulletin deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    
    SBSBulletin *bulletin = (SBSBulletin *)object;
    static NSString *CellIdentifier = @"bulletinCell";
    
    SBSBulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBSBulletinCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if (!IS_IOS_7) {
            cell.selectedBackgroundView = [SBSStyle selectedBackgroundView];
            cell.selectedBackgroundView.frame = cell.bounds;
        }
    }
    
    // Configure the cell
    cell.textLabel.text = bulletin.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Published: %@", nil), [[SBSStyle longStyleDateFormatter] stringFromDate:bulletin.createdAt]];
    cell.bodyLabel.text = bulletin.body;
    
    return cell;
}


#pragma mark - Table view data source

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SBSSecurity instance].currentUserStaffUser) {
        return indexPath;
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBSEditBulletinViewController *bulletinVC = [[SBSEditBulletinViewController alloc]init];
    bulletinVC.delegate = self;
    bulletinVC.bulletin = (SBSBulletin *)[self objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:bulletinVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SBSBulletin * object = (SBSBulletin *)[self objectAtIndexPath:indexPath];
    return [SBSBulletinCell heightForWidth:self.view._width withItem:object];
}

#pragma mark - Listen for security role changes

-(void)userRoleChanged:(NSNotification *)notification {
    [self updateBarButtonItemAnimated:YES];
}


@end
