//
//  LogInViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 30/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase

class LogViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var email: String?
    var password: String?
    var message: String?
    
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordTextField.autocorrectionType = .no
    }
    
    
    @IBAction func didPressLogIn(_ sender: Any) {
        let alert = UIAlertController(title: "Error", message: "Please insert username and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        if (!emailTextField.text!.isEmpty) && (!passwordTextField.text!.isEmpty) {
             email = emailTextField.text
             password = passwordTextField.text
           
            Auth.auth().signIn(withEmail: email!, password: password!) { (authResult, error) in
                if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    self.message = "Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console."
                case .userDisabled:
                    self.message = "Error: The user account has been disabled by an administrator."
                case .wrongPassword:
                    self.message = "Error: The password is invalid or the user does not have a password."
                case .invalidEmail:
                    self.message = "Error: Indicates the email address is malformed."
                default:
                    self.message = "Error: Something went wrong"
                let alert = UIAlertController(title: nil, message: self.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                }
              } else {
                    
                print("User signs in successfully")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserMainScreenVC") as! NavigationViewController
                 self.present(vc, animated: true, completion: nil)
              }
            }
        }
        else {
            self.present(alert, animated: true, completion: nil)
        }
        
       
    
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            pvc?.performSegue(withIdentifier: "goToSignUp", sender: nil)
        }
    }
    
    

  

}
