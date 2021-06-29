//
//  SignUpViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 30/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var ref: DatabaseReference = Database.database().reference()
    var username: String?
    var email: String?
    var password: String?
    var confirmedPass: String?
    var loginSuccess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        confirmPasswordTextField.autocorrectionType = .no
        emailTextField.textContentType = .none
        passwordTextField.textContentType = .none
        confirmPasswordTextField.textContentType = .none
        signUpButton.layer.cornerRadius = 5

    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        if (emailTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty) || (confirmPasswordTextField.text!.isEmpty) || (usernameTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please insert username and password", preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
            alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else if(passwordTextField.text! != confirmPasswordTextField.text!){
            let alert = UIAlertController(title: "Error", message: "Passwords must match!", preferredStyle: .alert)
            alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
            alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            username = usernameTextField.text
            email = emailTextField.text
            password = passwordTextField.text
            var availableUser: Bool = true
            
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                for (_, val) in value! {
                    if let stringValue = val as? NSDictionary {
                        if let valUsername = stringValue["username"] as? String {
                            if valUsername == self.username {
                                let alert = UIAlertController(title: nil, message: "Username is unavailable.", preferredStyle: .alert)
                                alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                                alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                self.present(alert, animated: true, completion: nil)
                                availableUser = false
                                break;
                            } } } }
                if availableUser {
                    Auth.auth().createUser(withEmail: self.email!, password: self.password!) {
                        (authResult, error) in
                        if let user = authResult?.user{
                            let uid = user.uid
                            self.ref.child("users").child(uid).setValue(["email": self.email!, "character nr": "0", "username": self.username!])
                            let signUpAlert = UIAlertController(title: nil, message: "User succesfully created! Please wait...", preferredStyle: .alert)
                            signUpAlert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                            signUpAlert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                           // signUpAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.emailTextField.text = ""
                            self.usernameTextField.text = ""
                            self.passwordTextField.text = ""
                            self.confirmPasswordTextField.text = ""
                            self.present(signUpAlert, animated: true)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.dismiss(animated: true, completion: nil)
                                                          let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LogViewController
                                                          self.present(vc, animated: true, completion: nil)
                            }
                          
                        } else {
                            if let error = error as NSError? {
                                var errorMessage: String = ""
                                switch AuthErrorCode(rawValue: error.code) {
                                case .operationNotAllowed:
                                    errorMessage = " Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section."
                                case .emailAlreadyInUse:
                                    errorMessage = "Error: The email address is already in use by another account."
                                case .invalidEmail:
                                    errorMessage = "Error: The email address is badly formatted."
                                case .weakPassword:
                                    errorMessage = "Error: The password must be 6 characters long or more."
                                default:
                                    errorMessage = "Error: \(error.localizedDescription)"
                                    
                                    let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
                                    alert.view.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
                                    alert.view.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                    self.present(alert, animated: true, completion: nil)
                                    self.loginSuccess = false
                                }
                            }
                        }
                    }
                }
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func didPressLogin(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
            pvc?.performSegue(withIdentifier: "goToLogin", sender: nil)
        }
    }
    
    
    
}
