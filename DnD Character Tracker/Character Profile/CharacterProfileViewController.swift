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

class CharacterProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var ref: DatabaseReference = Database.database().reference()
    var charNumber: Int = 0
    let user = Auth.auth().currentUser
    var experienceToLevelUp: [Int] = [300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, 305000, 355000]
    var level: Int = 1;
    var currentExp: Int = 0;
    var className: String = ""
    var raceName: String = ""
    
    var background: String = ""
    var HP : Int  = 0
    var AC: Int = 10
    var defaultHP: Int = 0
    var languages: [String] = []
    var stats: [String: String] = [:]
    var proficiencies: [String] = []
    var equipment: String = ""
    var characterName: String = ""
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var characterInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var expToAddTextField: UITextField!
    @IBOutlet weak var addExpButton: UIButton!
    @IBOutlet weak var currentExperienceLabel: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    @IBOutlet weak var inventoryTextView: UITextView!
    @IBOutlet weak var updateInventoryButton: UIButton!
    @IBOutlet weak var HP_ACLabel: UILabel!
    @IBOutlet weak var proficiencyLabel: UILabel!
    @IBOutlet weak var abilityScoreImprovementButton: UIButton!
    @IBOutlet weak var inventoryLabel: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        if let firstVC = presentingViewController as? CharacterListVC {
            DispatchQueue.main.async {
                firstVC.character = []
                firstVC.getCharacterList()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expToAddTextField.delegate = self
        abilityScoreImprovementButton.layer.cornerRadius = 2.5
        if !abilityScoreImprovementButton.isEnabled {
            abilityScoreImprovementButton.backgroundColor = #colorLiteral(red: 0.6691534991, green: 0.7516132072, blue: 0.7587246193, alpha: 1)
            abilityScoreImprovementButton.tintColor = #colorLiteral(red: 0.9333333333, green: 0.4235294118, blue: 0.3019607843, alpha: 1)
        } else {
            abilityScoreImprovementButton.backgroundColor = #colorLiteral(red: 0.5960784314, green: 0.7568627451, blue: 0.8509803922, alpha: 1)
            abilityScoreImprovementButton.tintColor = #colorLiteral(red: 0.2392156863, green: 0.3529411765, blue: 0.5019607843, alpha: 1)
        }
        levelUpButton.layer.cornerRadius = 2.5
        addExpButton.layer.cornerRadius = 2.5
        inventoryTextView.delegate = self
        inventoryLabel.text = "Inventory:"
        inventoryTextView.text = equipment
        updateInventoryButton.isEnabled = false
        nameLabel.text = characterName
        characterInfoLabel.text = "\(raceName) \(className), \(background) Background"
 
        switch(className.lowercased()) {
        case "barbarian": self.defaultHP = 12
        case "fighter", "paladin", "ranger": self.defaultHP = 10
        case "sorcerer", "wizard": self.defaultHP = 6
        default: self.defaultHP = 8
            
            inventoryTextView.layer.cornerRadius = 5
            inventoryTextView.layer.borderColor = #colorLiteral(red: 0.1607843137, green: 0.1960784314, blue: 0.2549019608, alpha: 1)
            inventoryTextView.layer.borderWidth = 1
        }
        
        updateHP_AC()
        levelLabel.text = "Level \(level)"
        
        if level < 20 {
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
            levelUpButton.isEnabled = currentExp >= experienceToLevelUp[level-1] ? true : false
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
        } else {
            currentExperienceLabel.isHidden = true
            levelUpButton.isHidden = true
            progressbar.isHidden = true
            expToAddTextField.isHidden = true
            addExpButton.isHidden = true
            abilityScoreImprovementButton.isHidden = true
        }
        
        
        languageLabel.text = "Known languages: "
        languages.sort()
        for i in 0 ..< languages.count {
            languageLabel.text?.append(languages[i])
            if i < languages.count - 1 {
                languageLabel.text?.append(", ")
            }
        }
        
        proficiencyLabel.text = "Proficiencies: "
        proficiencies.sort()
        for i in 0 ..< proficiencies.count {
            proficiencyLabel.text?.append(proficiencies[i])
            if i < proficiencies.count - 1 {
                proficiencyLabel.text?.append(", ")
            }
        }
        abilityScoreImprovementButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        abilityScoreImprovementButton.isEnabled = false
    }
 
    func getStats() {
        let uid = user?.uid
        ref.child("users").child(uid ?? "none").child("\(charNumber)").observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            let chStats = value!["stats"] as? [String: String] ?? [:]
            self.stats = chStats
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: Experience/Level up
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func didPressAddExp(_ sender: Any) {
        if let exp = Int(expToAddTextField.text ?? "0") {
            currentExp = currentExp + exp
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
            if currentExp >= experienceToLevelUp[level-1] {
                levelUpButton.isEnabled = true
            }
            self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/exp": "\(self.currentExp)"])
            expToAddTextField.text = ""
        }
    }
    
    @IBAction func didPressLevelUp(_ sender: Any) {
        level = Int(levelLabel.text!.components(separatedBy: " ")[1]) ?? 1
        levelLabel.text = "Level \(level+1)"
        
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/level": "\(self.level + 1)"])
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/exp": "\(self.currentExp)"])
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/hp": "\(self.HP)", "\(self.charNumber)/ac": "\(self.AC)"])
        
        
        if(level + 1 < 20) {
            currentExp = max(currentExp-experienceToLevelUp[level-1], 0)
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
            if currentExp >= experienceToLevelUp[level-1] {
                levelUpButton.isEnabled = true
            } else {
                levelUpButton.isEnabled = false
            }
           updateHP_AC()
            
        } else {
            abilityScoreImprovementButton.isHidden = true
            progressbar.isHidden = true
            currentExperienceLabel.isHidden = true
            levelUpButton.isHidden = true
            expToAddTextField.isHidden = true
            addExpButton.isHidden = true
        }
        switch(level+1) {
        case 4, 8, 12, 16, 19:
            abilityScoreImprovementButton.isEnabled = true
            levelUpButton.isEnabled = false
            addExpButton.isEnabled = false
        default:
            abilityScoreImprovementButton.isEnabled = false
        }
    }
    
    //MARK: Navigation
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: INVENTORY
    @IBAction func didPressUpdateInventory(_ sender: Any) {
        if let inventory = inventoryTextView.text {
        updateInventoryButton.isEnabled = false
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/equipment": "\(inventory)"])
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateInventoryButton.isEnabled = true
    }
    
    func updateHP_AC(){
        let CON = Int(stats["CON"] ?? "0")
        let CONModif = (CON ?? 10 > 9) ? ((CON ?? 10 - 10)/2) : -1
        self.HP = (self.defaultHP + CONModif)*level
        let DEX = Int(stats["DEX"] ?? "0")
        let DEXModif = (DEX ?? 10 > 9) ? ((DEX ?? 10 - 10)/2) : -1
        self.AC =  10 + DEXModif
        HP_ACLabel.text = "\(HP) HP     AC: \(AC) without armor"
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/hp": "\(self.HP)", "\(self.charNumber)/ac": "\(self.AC)"])
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAbilityImprovement",  let vc = segue.destination as? AbilityScoreImprovementViewController{
            vc.stats = self.stats
            vc.charNumber = self.charNumber
          
        }
    }
}
