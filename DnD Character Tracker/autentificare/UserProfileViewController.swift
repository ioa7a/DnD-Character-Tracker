//
//  UserProfileViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 29/06/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth



class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberOfCharacters: UILabel!
    
    let user = Auth.auth().currentUser
    var uid: String?
    var ref: DatabaseReference = Database.database().reference()
    var characterNumber: Int = 0
    var username: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = user?.uid
        
        ref.child("users").child(uid ?? "nil").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var chNr = 0
            if let nr = Int(value?["character nr"] as! String) {
                chNr = nr
            } else {
                chNr = 0
            }
            self.characterNumber = chNr
            self.username = value?["username"] as? String ?? "user"
            self.email = value?["email"] as? String
            self.emailLabel.text = "e-mail: \(self.email ?? "none")"
            self.userNameLabel.text = self.username
            if chNr == 1 {
                self.numberOfCharacters.text = "You currently have 1 character"
            } else {
                self.numberOfCharacters.text = "You currently have \(chNr) characters"
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        deleteAccountButton.layer.cornerRadius = 5
        deleteAccountButton.frame.size.height = 25.0
        
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressDeleteAccount(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Are you sure you want to delete your account?", message: nil, preferredStyle: .alert)
        deleteAlert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        deleteAlert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
        
        deleteAlert.addTextField { emailTextField in
            emailTextField.placeholder = "e-mail"
        }
        
        deleteAlert.addTextField { passTextField in
            passTextField.placeholder = "password"
            passTextField.isSecureTextEntry = true
        }
        
        
        
        deleteAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        let confirmAction = UIAlertAction(title: "CONFIRM", style: .default) { [weak deleteAlert] (_) in
            if let userEmail = deleteAlert?.textFields![0].text!, let userPass = deleteAlert?.textFields![1].text! {
                let credentials = EmailAuthProvider.credential(withEmail: userEmail, password: userPass)
                self.user?.reauthenticate(with: credentials) { (result, error) in
                    if let error = error {
                        let errorAlert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                        errorAlert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                        errorAlert
                            .view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        deleteAlert?.dismiss(animated: true, completion: nil)
                        self.present(errorAlert, animated: true)
                    } else {
                        self.user?.delete { error in
                            if let error = error {
                                let errorAlert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                                errorAlert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                                errorAlert
                                    .view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                deleteAlert?.dismiss(animated: true, completion: nil)
                                self.present(errorAlert, animated: true)
                            } else {
                                //stergere personaje
                                self.ref.child("users").child(self.uid ?? "nil").removeValue {(result, error) in
                                    debugPrint(error)
                                }
                                
                                //stergere conversatii
                                let db = Firestore.firestore().collection("Chats")
                                    .whereField("users", arrayContains: self.uid ?? "nil")
                                db.getDocuments { (chatQuerySnap, error) in
                                    if let error = error {
                                        print("Error: \(error)")
                                        return
                                    } else {
                                        for document in chatQuerySnap!.documents {
                                            document.reference.delete()
                                        }
                                    }
                                    
                                }
                                
                                //redirectionare la ecranul de start
                                deleteAlert?.dismiss(animated: true, completion: nil)
                                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                                
                            }
                        }
                    }
                    
                }
                
            }
        }
        deleteAlert.addAction(confirmAction)
        present(deleteAlert, animated: true)
    }
}
