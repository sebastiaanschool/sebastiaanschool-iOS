//
//  TeamTableViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit
import RealmSwift
import MessageUI

class TeamTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = contactItemsArray[indexPath.row]
        
        let displayName = selectedItem.displayName
        guard let emailRecipient = selectedItem.email else {
            let title = NSLocalizedString("Unknown email addres", comment: "Unknown email addres")
            let message = String.localizedStringWithFormat("No email address of %@ on file.", displayName)
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)
            return
        }
        guard MFMailComposeViewController.canSendMail() else {
            UIPasteboard.general.string = emailRecipient
            
            let title = NSLocalizedString("Your device can not send email", comment: "Your device can not send email")
            let message = String.localizedStringWithFormat("The email address %@ of %@ has been copied to the pasteboard.", emailRecipient, displayName)
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)

            return
        }
        
        let body = String.localizedStringWithFormat("Dear %@,\n\n", displayName)
        
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients([emailRecipient])
        mc.setMessageBody(body, isHTML: false)
        mc.setSubject("Test")
        //The navigation tint color is not propagated by UIAppearance for some reason. So setting it manually.
        mc.navigationBar.tintColor = .white
        present(mc, animated: true, completion: nil)

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

