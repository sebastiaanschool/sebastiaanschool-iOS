//
//  TeamTableViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit
import RealmSwift

class TeamTableViewController: UITableViewController {
    let realm = try! Realm()

    var contactItemsArray = try! Realm().objects(ContactItem.self).sorted(byProperty: "order", ascending: false)
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        SebastiaanApiClient.sharedApiClient.fetchContactItems { [weak self](contactItemsResult) in
            switch contactItemsResult {
            case .success(let contactItems):
                self?.realm.beginWrite()
                self?.realm.add(contactItems, update: true)
                try! self?.realm.commitWrite()

            default:
                print("Error: \(contactItemsResult)")
            }
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        self.title = NSLocalizedString("Team", comment: "Title of Team screen")


        // Set results notification block
        self.notificationToken = contactItemsArray.addNotificationBlock { (changes: RealmCollectionChange) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath)

        let contactItem = contactItemsArray[indexPath.row]
        cell.textLabel?.text = contactItem.displayName
        cell.detailTextLabel?.text = contactItem.detailText

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactItemsArray.count
    }
}
