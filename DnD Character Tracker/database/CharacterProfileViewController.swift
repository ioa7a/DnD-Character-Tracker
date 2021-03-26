//
//  CharacterProfileViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 13/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CharacterProfileViewController: UIViewController {
    var ref: DatabaseReference = Database.database().reference()
    var charNumber: Int = 0
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var characterInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var expToAddTextField: UITextField!
    @IBOutlet weak var addExpButton: UIButton!
    @IBOutlet weak var currentExperienceLabel: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    @IBOutlet var abilityScoreLabel: [UILabel]!
    @IBOutlet var abilityModifierLabel: [UILabel]!
    
    
    var experienceToLevelUp: [Int] = [300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, 305000, 355000]
    var level: Int = 1;
    var currentExp: Int = 0;
    var className: String = ""
    var raceName: String = ""
    var stats: [String: String] = [:]
    var background: String = ""
    var isOwnCharacter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterInfoLabel.text = "\(raceName) \(className), \(background) Background"
        levelLabel.text = "Level \(level)"
        currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
        
        progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
        progressbar.progressTintColor = .orange
        levelUpButton.isEnabled = false
        
        abilityScoreLabel[0].text = stats["CHA"]
        abilityScoreLabel[1].text = stats["CON"]
        abilityScoreLabel[2].text = stats["DEX"]
        abilityScoreLabel[3].text = stats["INT"]
        abilityScoreLabel[4].text = stats["STR"]
        abilityScoreLabel[5].text = stats["WIS"]
        
        currentExperienceLabel.isHidden = !isOwnCharacter
        levelUpButton.isHidden = !isOwnCharacter
        addExpButton.isHidden = !isOwnCharacter
        progressbar.isHidden = !isOwnCharacter
        expToAddTextField.isHidden = !isOwnCharacter
    }
    
    @IBAction func didPressAddExp(_ sender: Any) {
        if let exp = Int(expToAddTextField.text ?? "0") {
            currentExp = currentExp + exp
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
            if currentExp >= experienceToLevelUp[level-1] {
                levelUpButton.isEnabled = true
            }
            let user = Auth.auth().currentUser
            self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/exp": "\(self.currentExp)"])
            
        }
    }
    
    @IBAction func didPressLevelUp(_ sender: Any) {
        let user = Auth.auth().currentUser
        levelUpButton.isEnabled = false
        level = Int(levelLabel.text!.components(separatedBy: " ")[1]) ?? 1
        levelLabel.text = "Level " + String(level + 1)
        
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/level": "\(self.level + 1)"])
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/exp": "\(self.currentExp)"])
        
        
        if(level < 20) {
            currentExp = (currentExp-experienceToLevelUp[level-1]>0) ? currentExp-experienceToLevelUp[level-1] : 0
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
        } else {
            levelUpButton.isHidden = true
            addExpButton.isEnabled = false
        }
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "mesageUserSegue", let dest = segue.destination as? ChatViewController {
//            dest.user2Name = secondUserName
//        }
//    }
    
}
