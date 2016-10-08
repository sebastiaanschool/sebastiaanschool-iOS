//
//  InfoViewController.swift
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 07-10-16.
//
//

import UIKit

class InfoViewController : UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var agendaButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var yurlButton: UIButton!
    @IBOutlet weak var teamButton: UIButton!
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var bulletinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
