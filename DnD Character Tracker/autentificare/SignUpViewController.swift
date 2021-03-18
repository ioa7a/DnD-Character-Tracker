//
//  SignUpViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 30/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var ref: DatabaseReference = Database.database().reference()
    var username: String?
    var email: String?
    var password: String?
    var confirmedPass: String?
    var loginSuccess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        emailTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        confirmPasswordTextField.autocorrectionType = .no
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        if (emailTextField.text!.isEmpty) || (passwordTextField.text!.isEmpty) || (confirmPasswordTextField.text!.isEmpty) || (usernameTextField.text!.isEmpty){
            let alert = UIAlertController(title: "Error", message: "Please insert username and password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        else if(passwordTextField.text! != confirmPasswordTextField.text!){
            let alert = UIAlertController(title: "Error", message: "Passwords must match!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            username = usernameTextField.text
            email = emailTextField.text
            password = passwordTextField.text
            
            let signUpmanager = FirebaseAuthManager()
            signUpmanager.createUser(email: email!, password: password!) {[weak self] (success) in
                guard let self = self else { return }
                var message: String = ""
                if(success) {
                    message = "User succesfully created! Please wait..."
                    self.loginSuccess = true
                    let userKey = self.email?.components(separatedBy: "@")
                    self.ref.child("users").child(userKey![0]).setValue(["email": self.email!, "character nr": "0", "username": self.username!])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                               }
                } else {
                    let alert = UIAlertController(title: nil, message: signUpmanager.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: true, completion: nil)
                    self.loginSuccess = false
                }
                let signUpAlert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                signUpAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(signUpAlert, animated: true)
                if self.loginSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: true, completion: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! LogViewController
                        self.present(vc, animated: true, completion: nil)
                }
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    @IBAction func didPressLogin(_ sender: Any) {
        weak var pvc = self.presentingViewController
        dismiss(animated: true) {
        pvc?.performSegue(withIdentifier: "goToLogin", sender: nil)
              }
    }

    
    
}
