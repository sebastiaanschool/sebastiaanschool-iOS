//
//  BulletinViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 28-08-16.
//
//

import UIKit
import RealmSwift

class BulletinViewController: UITableViewController {
    let realm = try! Realm()

    var bulletinsArray = try! Realm().objects(Bulletin.self).sorted(byProperty: "publishedAt", ascending: false)
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        SebastiaanApiClient.sharedApiClient.fetchBulletins { [weak self](bulletinsResult) in
            switch bulletinsResult {
            case .success(let bulletins):
                self?.realm.beginWrite()
                self?.realm.add(bulletins, update: true)
                try! self?.realm.commitWrite()

            default:
                print("Error: \(bulletinsResult)")
            }
        }


        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)

        self.title = NSLocalizedString("Bulletin", comment: "Title of Bulletin screen")


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
}
