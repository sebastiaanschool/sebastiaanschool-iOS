//
//  AgendaTableViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit
import RealmSwift

class AgendaTableViewController: UITableViewController {
    let realm = try! Realm()
    
    var agendaItemsArray = try! Realm().objects(AgendaItem.self).sorted(byProperty: "start", ascending: false)
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SebastiaanApiClient.sharedApiClient.fetchAgendaItems{ [weak self](agendaItemResult) in
            switch agendaItemResult {
            case .success(let agendaItems):
                self?.realm.beginWrite()
                self?.realm.add(agendaItems, update: true)
                try! self?.realm.commitWrite()
                
            default:
                print("Error: \(agendaItemResult)")
            }
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        self.title = NSLocalizedString("Agenda", comment: "Title of Agenda screen")
        
        // Set results notification block
        self.notificationToken = agendaItemsArray.addNotificationBlock { (changes: RealmCollectionChange) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "agendaCell", for: indexPath)
        
        let agendaItem = agendaItemsArray[indexPath.row]
        cell.textLabel?.text = agendaItem.title
        
        if let startDate = agendaItem.start, let endDate = agendaItem.end {
            cell.detailTextLabel?.text = String.localizedStringWithFormat("%@ - %@", SebastiaanStyle.longStyleDateFormatter.string(from: startDate), SebastiaanStyle.longStyleDateFormatter.string(from: endDate))
        } else if let startDate = agendaItem.start {
            cell.detailTextLabel?.text = SebastiaanStyle.longStyleDateFormatter.string(from: startDate)
        } else {
            print("Missing start and end on event.")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaItemsArray.count
    }
}

