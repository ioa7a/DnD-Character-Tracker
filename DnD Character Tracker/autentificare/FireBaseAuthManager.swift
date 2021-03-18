//
//  FireBaseAuthManager.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 30/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirebaseAuthManager {
    var message: String?
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authResult, error) in
            if let user = authResult?.user{
                print(user)
                completionBlock(true)
            } else {
                if let error = error as NSError? {
                 
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                self.message = " Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section."
                case .emailAlreadyInUse:
                    self.message = "Error: The email address is already in use by another account."
                case .invalidEmail:
                    self.message = "Error: The email address is badly formatted."
                case .weakPassword:
                    self.message = "Error: The password must be 6 characters long or more."
                default:
                    self.message = "Error: \(error.localizedDescription)"
                }
                   
                }
                completionBlock(false)
            }
        }
        
    }
}
