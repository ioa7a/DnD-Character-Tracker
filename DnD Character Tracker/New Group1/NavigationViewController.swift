//
//  ViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 02/10/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase

class NavigationViewController: UIViewController {
    var username: String = "user"
    let user = Auth.auth().currentUser
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet var navigationButtons: [UIButton]!
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in navigationButtons {
            button.layer.cornerRadius = 5
        }
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        self.view.addSubview(navBar)
        navBar.backgroundColor = self.view.backgroundColor
        let logOutButton = UIBarButtonItem(title: "LOG OUT", style: .plain, target: self, action: #selector(onLogout))
        
        var image = UIImage.init(systemName: "envelope.fill")
        image = image?.withRenderingMode(.alwaysTemplate)
       image?.withTintColor(.systemBlue)
        let messageButton  = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(onMessage))
        messageButton.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        logOutButton.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        navBar.barTintColor = #colorLiteral(red: 0.8784313725, green: 0.9843137255, blue: 0.9882352941, alpha: 1)
        self.navigationItem.leftBarButtonItem = logOutButton
        self.navigationItem.rightBarButtonItem = messageButton
        navBar.items?.append(navigationItem)
        
        ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String ?? "user"
            self.welcomeLabel.text =  "Welcome " + self.username + "!"
        }) { (error) in
            print(error.localizedDescription)
        }}
        
        
    
    @objc func onLogout() {
        var err: Bool = false;
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error")
            err = true
        }
        if !err {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onMessage(){
        performSegue(withIdentifier: "goToChatIndex", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatIndex", let vc = segue.destination as? ChatIndexViewController {
            vc.userName = username
        }
    }
    
}

