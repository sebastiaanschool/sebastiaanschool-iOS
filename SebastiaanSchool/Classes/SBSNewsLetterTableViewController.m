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

#import "TFHpple.h"

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
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:nil action:nil];
            @weakify(self);
            addButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
                @strongify(self);
                [self refreshNewsletters];
                return [RACSignal empty];
            }];
            [self.navigationItem setRightBarButtonItem:addButton animated:animated];
        }
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:animated];
    }
}

- (void)refreshNewsletters {
    [self trackEvent:@"Refreshing newsletters"];

    PFQuery * configQuery = [SBSConfig query];
    @weakify(self);
    [configQuery findObjectsInBackgroundWithBlock:^(NSArray *configObjects, NSError *error) {
        @strongify(self);
        if (error) {
            // Log details of the failure
            ULog(@"Error: %@ %@", error, [error userInfo]);
            return;
        }
        
        NSString *newsletterDiscoveryBaseUrl; // Example: @"http://www.sebastiaanschool.nl"
        NSString *newsletterDiscoveryPageUrl; // Example: @"http://www.sebastiaanschool.nl/sebastiaanschool.nl/nieuwsbrief.html"
        NSString *newsletterDiscoveryTitleXpath; // Example: @"//li[@id='cat_1098']/ul/li/a/span"
        NSString *newsletterDiscoveryUrlXpath; // Example: @"//li[@id='cat_1098']/ul/li/a/@href"
        for (SBSConfig *obj in configObjects) {
            NSString *key = obj.key;
            if ([SBSNewsletterDiscoveryBaseUrl isEqual:key]) {
                newsletterDiscoveryBaseUrl = obj.value;
            } else if ([SBSNewsletterDiscoveryPageUrl isEqual:key]) {
                newsletterDiscoveryPageUrl = obj.value;
            } else if ([SBSNewsletterDiscoveryTitleXpath isEqual:key]) {
                newsletterDiscoveryTitleXpath = obj.value;
            } else if ([SBSNewsletterDiscoveryUrlXpath isEqual:key]) {
                newsletterDiscoveryUrlXpath = obj.value;
            }
        }
        
        if (newsletterDiscoveryUrlXpath == nil || newsletterDiscoveryTitleXpath == nil || newsletterDiscoveryBaseUrl == nil || newsletterDiscoveryPageUrl == nil) {
            NSLog(@"Error missing parameter for newsletter refresh. newsletterDiscoveryPageUrl: %@ newsletterDiscoveryBaseUrl: %@ newsletterDiscoveryTitleXpath:%@ newsletterDiscoveryUrlXpath: %@", newsletterDiscoveryPageUrl, newsletterDiscoveryBaseUrl, newsletterDiscoveryTitleXpath, newsletterDiscoveryUrlXpath);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Newsletter config is incomplete.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];

            return;
        }
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:newsletterDiscoveryPageUrl]];
        TFHpple *doc = [[TFHpple alloc]initWithHTMLData:data];

    
        NSArray *hrefElements = [doc searchWithXPathQuery:newsletterDiscoveryUrlXpath];
        NSArray *spanElements = [doc searchWithXPathQuery:newsletterDiscoveryTitleXpath];
        NSString * baseUrlString = newsletterDiscoveryBaseUrl;

        if (hrefElements.count == 0 || spanElements.count == 0) {
            ULog(@"Refreshing newsletters failed: zero arrays returned: href elements: %@ span elements: %@", hrefElements, spanElements);
            return;
        }
        if (hrefElements.count != spanElements.count) {
            ULog(@"Refreshing newsletters failed: non matching href and span counts.");
            return;
        }
        
        NSMutableArray *newsLetterUrls = [NSMutableArray array];
        [hrefElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TFHppleElement * element = obj;
            NSString * url = [baseUrlString stringByAppendingPathComponent:element.firstChild.content];
            url = [url stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
            [newsLetterUrls addObject:url];
        }];
        
        NSMutableArray *newsLetterNames = [NSMutableArray array];
        [spanElements enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TFHppleElement * element = obj;
            [newsLetterNames addObject:element.firstChild.content];
        }];

        PFQuery * query = [self queryForTable];
        [query findObjectsInBackgroundWithBlock:^(NSArray *newsletterObjects, NSError *error) {
            @strongify(self);
          if (error) {
              // Log details of the failure
              ULog(@"Error: %@ %@", error, [error userInfo]);
              return;
          }
          // The find succeeded.
          NSLog(@"Successfully retrieved %d newsletters.", newsletterObjects.count);
          
          for (SBSNewsLetter * obj in newsletterObjects) {
              if([newsLetterNames containsObject:obj.name] && [newsLetterUrls containsObject:obj.url]) {
                  //This one is not updated
                  NSUInteger index = [newsLetterNames indexOfObject:obj.name];
                  [newsLetterNames removeObjectAtIndex:index];
                  [newsLetterUrls removeObjectAtIndex:index];
              } else if ([newsLetterNames containsObject:obj.name]) {
                  NSUInteger index = [newsLetterNames indexOfObject:obj.name];
                  NSString *newUrl = [newsLetterUrls objectAtIndex:index];
                  
                  [newsLetterNames removeObjectAtIndex:index];
                  [newsLetterUrls removeObjectAtIndex:index];
                  
                  obj.url = newUrl;
                  [obj saveInBackground];
              } else if([newsLetterUrls containsObject:obj.url]) {
                  NSUInteger index = [newsLetterNames indexOfObject:obj.url];
                  NSString *newName = [newsLetterNames objectAtIndex:index];

                  [newsLetterNames removeObjectAtIndex:index];
                  [newsLetterUrls removeObjectAtIndex:index];
                  
                  obj.name = newName;
                  [obj saveInBackground];
              } else {
                  [obj deleteInBackground];
              }
          }
          
          for (NSUInteger index = 0; index < newsLetterNames.count; index++) {
              SBSNewsLetter *obj = [[SBSNewsLetter alloc]init];
              obj.name = [newsLetterNames objectAtIndex:index];
              obj.url = [newsLetterUrls objectAtIndex:index];

              [obj saveInBackground];
          }
          [self loadObjects];
        }];
    }];

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

#pragma mark - Listen for security role changes

-(void)userRoleChanged:(NSNotification *)notification {
    [self updateBarButtonItemAnimated:YES];
}


@end
