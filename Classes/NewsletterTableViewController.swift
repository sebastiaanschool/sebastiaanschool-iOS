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

    var newsletterArray = try! Realm().objects(Newsletter.self).sorted(byProperty: "publishedAt", ascending: false)
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SebastiaanApiClient.sharedApiClient.fetchNewsletters { [weak self](newslettersResult) in
            switch newslettersResult {
            case .success(let newsletters):
                self?.realm.beginWrite()
                self?.realm.add(newsletters, update: true)
                try! self?.realm.commitWrite()
                
            default:
                print("Error: \(newslettersResult)")
            }
        }

        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        self.title = NSLocalizedString("Newsletter", comment: "Title of Team screen")

        
        // Set results notification block
        self.notificationToken = newsletterArray.addNotificationBlock { (changes: RealmCollectionChange) in
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsletterCell", for: indexPath)
        
        let newsletter = newsletterArray[indexPath.row]
        cell.textLabel?.text = newsletter.title.capitalized
        cell.detailTextLabel?.text = String.localizedStringWithFormat(NSLocalizedString("Published: %@", comment: "Published at"), SebastiaanStyle.longStyleDateFormatter.string(from: newsletter.publishedAt))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsletterArray.count
    }
}

//TODO
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 SBSNewsLetter *newsLetter = (SBSNewsLetter *)[self objectAtIndexPath:indexPath];
 SBSNewsLetterViewController *newsletterViewController = [[SBSNewsLetterViewController alloc]initWithNewsLetter:newsLetter];
 newsletterViewController.title = [newsLetter.name capitalizedString];
 [self.navigationController pushViewController:newsletterViewController animated:YES];
 }
 @end

 */

