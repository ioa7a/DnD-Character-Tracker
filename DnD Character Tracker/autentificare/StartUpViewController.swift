//
//  LogInViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 30/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit

class StartUpViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.layer.cornerRadius = 25
        titleLabel.clipsToBounds = true
        loginButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
    }

}
