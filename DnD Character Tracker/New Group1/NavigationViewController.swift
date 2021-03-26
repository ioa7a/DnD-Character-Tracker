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
    
    @IBOutlet weak var logOutButton: CustomButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

            ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.username = value?["username"] as? String ?? "user"
                self.welcomeLabel.text =  "Welcome " + self.username + "!"
            }) { (error) in
                print(error.localizedDescription)
            }
        
        
    }
    
    @IBAction func didPressLogOut(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChatIndex", let vc = segue.destination as? ChatIndexViewController {
            vc.userName = username
        }
    }
    
}

