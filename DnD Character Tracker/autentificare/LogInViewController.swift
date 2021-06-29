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

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var email: String?
    var password: String?
    var message: String?
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.text = ""
        passwordTextField.text = ""
        passwordTextField.autocorrectionType = .no
        logInButton.sizeToFit()
        emailLabel.clipsToBounds = true
        emailLabel.layer.cornerRadius = 5
        passwordLabel.clipsToBounds = true
        passwordLabel.layer.cornerRadius = 5
        logInButton.layer.cornerRadius = 5
    }
    
    
    @IBAction func didPressLogIn(_ sender: Any) {
        let alert = UIAlertController(title: "Error", message: "Please insert username and password", preferredStyle: .alert)
        alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
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
                    self.message = "Error: Incorrect username or password."
                let alert = UIAlertController(title: nil, message: self.message, preferredStyle: .alert)
                alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                }
              } else {
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
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            pvc?.performSegue(withIdentifier: "goToSignUp", sender: nil)
        }
    }
    
    

  

}
