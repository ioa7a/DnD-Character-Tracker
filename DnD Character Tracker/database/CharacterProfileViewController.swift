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

class CharacterProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    var ref: DatabaseReference = Database.database().reference()
    var charNumber: Int = 0
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var inventoryTextView: UITextView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var characterInfoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet weak var expToAddTextField: UITextField!
    @IBOutlet weak var addExpButton: UIButton!
    @IBOutlet weak var currentExperienceLabel: UILabel!
    @IBOutlet weak var levelUpButton: UIButton!
    @IBOutlet var abilityScoreLabel: [UILabel]!
    
    @IBOutlet var abilityModifierLabel: [UILabel]!
     
    @IBOutlet weak var HP_ACLabel: UILabel!
    @IBOutlet weak var abilityCollectionView: UICollectionView!
    @IBOutlet weak var proficiencyLabel: UILabel!
    @IBOutlet weak var abilityScoreImprovementButton: UIButton!
    
    
    var canImproveAbilityScore: Bool = false
    var collectionViewDataSource: [String] = ["Athletics", "Acrobatics", "Sleight of Hand", "Stealth", "Arcana", "History", "Investigation", "Nature", "Religion", "Animal Handling", "Insight", "Medicine", "Perception", "Survival", "Deception", "Intimidation", "Performance", "Persuasion"]
    
    var experienceToLevelUp: [Int] = [300, 900, 2700, 6500, 14000, 23000, 34000, 48000, 64000, 85000, 100000, 120000, 140000, 165000, 195000, 225000, 265000, 305000, 355000]
    var level: Int = 1;
    var currentExp: Int = 0;
    var className: String = ""
    var raceName: String = ""
    var stats: [String: String] = [:]
    var background: String = ""
    var HP : Int  = 0
    var AC: Int = 10
    var defaultHP: Int = 0
    var languages: [String] = []
    var proficiencies: [String] = []
    var equipment: String = ""
    var characterName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abilityCollectionView.delegate = self
        abilityCollectionView.dataSource = self
        inventoryTextView.delegate = self
        
        nameLabel.text = characterName
        characterInfoLabel.text = "\(raceName) \(className), \(background) Background"
        inventoryTextView.text = equipment
        
        abilityScoreLabel[0].text = stats["CHA"]
        abilityScoreLabel[1].text = stats["CON"]
        abilityScoreLabel[2].text = stats["DEX"]
        abilityScoreLabel[3].text = stats["INT"]
        abilityScoreLabel[4].text = stats["STR"]
        abilityScoreLabel[5].text = stats["WIS"]
        calculateModifier()
        
        switch(className.lowercased()) {
        case "barbarian": self.defaultHP = 12
        case "fighter", "paladin", "ranger": self.defaultHP = 10
        case "sorcerer", "wizard": self.defaultHP = 6
        default: self.defaultHP = 8
        }
        
        updateHP_AC()
        levelLabel.text = "Level \(level)"
        
        if level < 20 {
            currentExperienceLabel.text = "\(currentExp)/\(experienceToLevelUp[level-1])"
            levelUpButton.isEnabled = currentExp >= experienceToLevelUp[level-1] ? true : false
            progressbar.progress = Float(currentExp)/Float(experienceToLevelUp[level-1])
            progressbar.progressTintColor = .systemBlue
        } else {
            currentExperienceLabel.isHidden = true
            levelUpButton.isHidden = true
            progressbar.isHidden = true
            expToAddTextField.isHidden = true
        }
        
        
        languageLabel.text = "Known languages: "
        languages.sort()
        for i in 0 ..< languages.count {
            languageLabel.text?.append(languages[i])
            if i < languages.count - 1 {
                languageLabel.text?.append(", ")
            }
        }
        
        proficiencyLabel.text = "Known languages: "
        proficiencies.sort()
        for i in 0 ..< proficiencies.count {
            proficiencyLabel.text?.append(proficiencies[i])
            if i < proficiencies.count - 1 {
                proficiencyLabel.text?.append(", ")
            }
        }
        
        abilityScoreImprovementButton.isEnabled = canImproveAbilityScore ? true : false
    }
    
    func getStats() {
        let uid = user?.uid
        ref.child("users").child(uid ?? "none").child("\(charNumber)").observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            let chStats = value!["stats"] as? [String: String] ?? [:]
            self.stats = chStats
            self.abilityScoreLabel[0].text = self.stats["CHA"]
            self.abilityScoreLabel[1].text = self.stats["CON"]
            self.abilityScoreLabel[2].text = self.stats["DEX"]
            self.abilityScoreLabel[3].text = self.stats["INT"]
            self.abilityScoreLabel[4].text = self.stats["STR"]
            self.abilityScoreLabel[5].text = self.stats["WIS"]
            self.calculateModifier()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: Experience/Level up
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
        default:
            abilityScoreImprovementButton.isEnabled = false
        }
    }
    
    //MARK: Navigation
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Calculate/Update Stats
    
    func calculateModifier(){
        for i in 0...5 {
            var modifier: Int = 0;
            guard let total = Int(abilityScoreLabel[i].text!) else { return }
            if total == 9 {
                modifier = -1
            } else {
                modifier = Int((total - 10)/2)
            }
            if modifier >= 0 {
                abilityModifierLabel[i].text = "+\(modifier)"
            } else {
                abilityModifierLabel[i].text = String(modifier)
            }
        }
    }
    
    func updateHP_AC(){
        let CONModif = abilityModifierLabel[1].text
        self.HP = (self.defaultHP + Int(CONModif ?? "0")!)*level
        HP_ACLabel.text = "\(HP) HP     AC: \(AC) without armor"
        
        let DEXModif = abilityModifierLabel[1].text
        self.AC =  10 + Int(DEXModif ?? "0")!
        HP_ACLabel.text = "\(HP) HP     AC: \(AC) without armor"
        
        
        self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber)/hp": "\(self.HP)", "\(self.charNumber)/ac": "\(self.AC)"])
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 165.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = abilityCollectionView.dequeueReusableCell(withReuseIdentifier: "abilityCell", for: indexPath) as? CharacterAbilityCollectionViewCell{
            cell.abilityLabel.text = collectionViewDataSource[indexPath.row]
            var score: Int = 0
            switch(cell.abilityLabel.text) {
            case "Deception", "Intimidation", "Performance", "Persuasion":
                score = Int(abilityModifierLabel[0].text!) ?? 0
                cell.layer.borderColor = UIColor.systemBlue.cgColor
                cell.abilityLabel.text?.append("\n(CHA)")
            case "Acrobatics", "Sleight of Hand", "Stealth":
                score = Int(abilityModifierLabel[2].text!) ?? 0
                cell.layer.borderColor = UIColor.systemOrange.cgColor
                cell.abilityLabel.text?.append("\n(DEX)")
            case "Arcana", "History", "Investigation", "Nature", "Religion":
                score = Int(abilityModifierLabel[3].text!) ?? 0
                cell.layer.borderColor = UIColor.systemYellow.cgColor
                 cell.abilityLabel.text?.append("\n(INT)")
            case "Athletics":
                score = Int(abilityModifierLabel[4].text!) ?? 0
                cell.layer.borderColor = UIColor.systemRed.cgColor
                cell.abilityLabel.text?.append("\n(STR)")
           
            case "Animal Handling", "Insight", "Medicine", "Perception", "Survival":
                score = Int(abilityModifierLabel[5].text!) ?? 0
                cell.layer.borderColor = UIColor.systemGreen.cgColor
                cell.abilityLabel.text?.append("\n(WIS)")
           
            default:  cell.layer.borderColor = UIColor.systemGray.cgColor
            }
            
            if proficiencies.contains(cell.abilityLabel.text ?? "none") {
                switch(level) {
                case 1 ... 4: score = score + 2
                case 5 ... 8: score = score + 3
                case 9 ... 12: score = score + 4
                case 13 ... 16: score = score + 5
                case 17 ... 20: score = score + 6
                default: break
                }
            }
            cell.abilityScoreLabel.text = (score >= 0 ? "+ \(score)" : " \(score)")
            cell.layer.borderWidth = 2.0
            return cell
            
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAbilityImprovement",  let vc = segue.destination as? AbilityScoreImprovementViewController{
            vc.stats = self.stats
            vc.charNumber = self.charNumber
          //  vc.charProfileVC = self
          
        }
    }
    

}
