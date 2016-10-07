//
//  BulletinViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 28-08-16.
//
//

import UIKit
import RealmSwift

class NewsletterTableViewController: UITableViewController {
    let realm = try! Realm()

    var bulletinsArray = try! Realm().objects(Newsletter.self).sorted(byProperty: "publishedAt", ascending: false)
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set results notification block
        self.notificationToken = bulletinsArray.addNotificationBlock { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                    with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                    with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                    with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
    }

}

//TODO
/*
 
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
 
 self.title = NSLocalizedString(@"Newsletter", nil);
 }
 
 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the first key in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 SBSNewsLetter *newsletter = (SBSNewsLetter *)object;
 static NSString *CellIdentifier = @"newsLetterCell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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

 */
/*
// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSNewsLetterViewController.h
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//
//

#import <ParseUI/ParseUI.h>

@interface SBSNewsLetterTableViewController : PFQueryTableViewController

@end
 
 */

/*
 
 // SebastiaanSchool (c) 2014 by Jeroen Leenarts
 //
 // SebastiaanSchool is licensed under a
 // Creative Commons Attribution-NonCommercial 3.0 Unported License.
 //
 // You should have received a copy of the license along with this
 // work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
 //
 //  SBSNewsLetterViewController.m
 //  SebastiaanSchool
 //
 //  Created by Jeroen Leenarts on 11-01-13.
 //
 
 #import "SBSNewsLetterTableViewController.h"
 #import "SBSNewsLetterViewController.h"
 
 #import "SBSNewsLetter.h"
 
 @interface SBSNewsLetterTableViewController ()
 
 @end
 
 @implementation SBSNewsLetterTableViewController
 
 - (void)dealloc
 {
 [[NSNotificationCenter defaultCenter]removeObserver:self];
 }
 
 -(id)initWithCoder:(NSCoder *)aDecoder
 {
 self = [super initWithCoder:aDecoder];
 if (self) {
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
 - (id)initWithStyle:(UITableViewStyle)style
 {
 self = [super initWithStyle:style];
 if (self) {
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
 
 self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
 
 self.title = NSLocalizedString(@"Newsletter", nil);
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
 @end

 */

