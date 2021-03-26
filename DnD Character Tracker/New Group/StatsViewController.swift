//
//  StatsViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 01/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet var racialModifierLabel: [UILabel]!
    @IBOutlet var abilityButton: [UIButton]!
    @IBOutlet var totalAbilityScoreLabel: [UILabel]!
    @IBOutlet var overallModifierLabel: [UILabel]!
    @IBOutlet var abilityScoreLabel: [UILabel]!
    
    @IBOutlet weak var increaseScore: UIButton!
    @IBOutlet weak var decreaseScore: UIButton!
    @IBOutlet weak var abilityDescriptionLabel: UILabel!
    @IBOutlet weak var pointsUsedLabel: UILabel!
    
    @IBOutlet weak var bonusAbility1Button: UIButton!
    @IBOutlet weak var bonusPicker1: UIPickerView!
    @IBOutlet weak var bonusPicker2: UIPickerView!
    
    @IBOutlet weak var createCharacterButton: UIButton!
    
    var race: String?
    var raceIndex: Int = 0
    var modifiers: [Int] = []
    var bonusAdded: Bool = false
    var bonusIndex1: Int = -1;
    var bonusIndex2: Int = -1;
    var charNumber: Int = 0
    
    var abilityDescription: [String] = [
        "Charisma measures force of personality, persuasiveness, leadership and successful planning. Important for Bards, Sorcerers and Warlocks.",
        "Constitution measures endurance, stamina and good health. Important for every class",
        "Dexterity measures agility, balance, coordination and reflexes. Important for  Monks, Rangers and Rogues.",
        "Intelligence measures deductive reasoning, knowledge, memory, logic and rationality. Important for Wizards.",
        "Strength measures physical power and carrying capacity. Important for Barbarians, Fighters and Paladins.",
        "Wisdom measures self-awareness, common sense, restraint, perception and insight. Important for Clerics and Druids."]
    
    var abilities: [String] = ["Charisma", "Constitution", "Dexterity", "Intelligence", "Strength", "Wisdom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("races").child(String(raceIndex)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            debugPrint(name)
            if name == "half-elf"{
                self.bonusAbility1Button.isHidden = false
                self.bonusPicker1.isHidden = false
                self.bonusPicker2.isHidden = false
                
            } else {
                self.bonusAbility1Button.isHidden = true
                self.bonusPicker1.isHidden = true
                self.bonusPicker2.isHidden = true
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("races").child(String(raceIndex)).child("modifiers").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.modifiers = [value?["CHA"] as! Int, value?["CON"] as! Int, value?["DEX"] as! Int, value?["INT"] as! Int, value?["STR"] as! Int, value?["WIS"] as! Int]
            for i in 0...5 {
                self.racialModifierLabel[i].text = String(self.modifiers[i])
                self.updateTotalScore()
                self.calculateModifier()
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        bonusPicker1.delegate = self
        bonusPicker1.dataSource = self
        bonusPicker2.delegate = self
        bonusPicker2.dataSource = self
        abilityDescriptionLabel.isHidden = true
        abilityButton.forEach{button in
            button.isSelected = false}
        
    }
    
    @IBAction func selectCHA(_ sender: Any) {
        abilitySelected(index: 0)
    }
    
    @IBAction func selectCon(_ sender: Any) {
        abilitySelected(index: 1)
    }
    
    @IBAction func selectDEX(_ sender: Any) {
        abilitySelected(index: 2)
    }
    
    @IBAction func selectINT(_ sender: Any) {
        abilitySelected(index: 3)
    }
    
    @IBAction func selectSTR(_ sender: Any) {
        abilitySelected(index: 4)
    }
    
    @IBAction func selectWIS(_ sender: Any) {
        abilitySelected(index: 5)
    }
    
    func abilitySelected(index: Int) {
        abilityButton[index].isSelected = !abilityButton[index].isSelected
        if(abilityButton[index].isSelected){
            for i in 0...5 {
                if abilityButton[i].isSelected && i != index {
                    abilityButton[i].isSelected = false
                }
            }
            abilityDescriptionLabel.isHidden = false
            abilityDescriptionLabel.text = abilityDescription[index]}
        else {
            abilityDescriptionLabel.isHidden = true
            for i in 0...5 {
                if abilityButton[i].isSelected && i != index {
                    abilityButton[i].isSelected = true
                }
            }
        }
    }
    
    
    @IBAction func didPressDecreaseScore(_ sender: UIButton) {
        for i in 0...5 {
            if abilityButton[i].isSelected {
                let index = abilityButton[i].tag
                guard let currentScore = Int(abilityScoreLabel[index].text!) else { return }
                if currentScore > 8 {
                    abilityScoreLabel[index].text = String(currentScore-1)
                    guard let totalScore = Int(pointsUsedLabel.text!) else { return }
                    pointsUsedLabel.text = String(totalScore-1)
                }
                break
            }
        }
        updateTotalScore()
        calculateModifier()
    }
    
    
    @IBAction func didPressIncreaseScore(_ sender: UIButton) {
        for i in 0...5 {
            if abilityButton[i].isSelected {
                let index = abilityButton[i].tag
                guard let currentScore = Int(abilityScoreLabel[index].text!) else { return }
                if currentScore < 15 {
                    abilityScoreLabel[index].text = String(currentScore+1)
                    guard let totalScore = Int(pointsUsedLabel.text!) else { return }
                    pointsUsedLabel.text = String(totalScore+1)
                }
            }
        }
        updateTotalScore()
        calculateModifier()
        
    }
    
    func updateTotalScore(){
        for i in 0...5 {
            guard let currentScore = Int(abilityScoreLabel[i].text!) else { return }
            guard let racialModifier = Int(racialModifierLabel[i].text!) else { return }
            totalAbilityScoreLabel[i].text = String(currentScore+racialModifier)
        }
    }
    
    func calculateModifier(){
        for i in 0...5 {
            var modifier: Int = 0;
            guard let total = Int(totalAbilityScoreLabel[i].text!) else { return }
            if total == 9 {
                modifier = -1
            } else {
                modifier = Int((total - 10)/2)
            }
            overallModifierLabel[i].text = String(modifier)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return abilities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return abilities[row]
    }
    
    @IBAction func didPressBonusAbility(_ sender: Any) {
        if(!bonusAdded){
            if bonusPicker1.selectedRow(inComponent: 0) == bonusPicker2.selectedRow(inComponent: 0) {
                let alert = UIAlertController(title: "", message: "Abilities must be different!", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            } else {
                bonusAdded = true
                guard let currentValue1 = Int((racialModifierLabel?[bonusPicker1.selectedRow(inComponent: 0)].text)!) else { return }
                racialModifierLabel?[bonusPicker1.selectedRow(inComponent: 0)].text = String(currentValue1+1)
                bonusIndex1 = bonusPicker1.selectedRow(inComponent: 0)
                guard let currentValue2 = Int((racialModifierLabel?[bonusPicker2.selectedRow(inComponent: 0)].text)!) else { return }
                racialModifierLabel?[bonusPicker2.selectedRow(inComponent: 0)].text = String(currentValue2+1)
                bonusIndex2 = bonusPicker2.selectedRow(inComponent: 0)
                updateTotalScore()
                calculateModifier()
            }
        }
        else {
            guard let oldValue1 = Int((racialModifierLabel?[bonusIndex1].text)!) else { return }
            racialModifierLabel?[bonusIndex1].text = String(oldValue1-1)
            bonusIndex1 = bonusPicker1.selectedRow(inComponent: 0)
            guard let oldValue2 = Int((racialModifierLabel?[bonusIndex2].text)!) else { return }
            racialModifierLabel?[bonusIndex2].text = String(oldValue2-1)
            bonusIndex2 = bonusPicker2.selectedRow(inComponent: 0)
            
            guard let currentValue1 = Int((racialModifierLabel?[bonusPicker1.selectedRow(inComponent: 0)].text)!) else { return }
            racialModifierLabel?[bonusPicker1.selectedRow(inComponent: 0)].text = String(currentValue1+1)
            guard let currentValue2 = Int((racialModifierLabel?[bonusPicker2.selectedRow(inComponent: 0)].text)!) else { return }
            racialModifierLabel?[bonusPicker2.selectedRow(inComponent: 0)].text = String(currentValue2+1)
            
            updateTotalScore()
            calculateModifier()
        }
        
    }
    
    @IBAction func didPressCreate(_ sender: Any) {
        guard let totalScore = Int(pointsUsedLabel.text!) else { return }
        if totalScore == 27 {
            let user = Auth.auth().currentUser
            var stat : [String: String] = [:]
            for i in 0 ..< abilityButton.count {
                stat[abilityButton[i].titleLabel!.text!] = totalAbilityScoreLabel[i].text
            }
            ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.charNumber = Int(value?["character nr"] as! String) ?? 0
                self.ref.child("users").child(user!.uid).updateChildValues(["\(self.charNumber+1)/stats" : stat, "\(self.charNumber+1)/level": "1"])
                self.ref.child("users").child(user!.uid).updateChildValues(["character nr" : "\(self.charNumber+1)"])
            })
            { (error) in
                print(error.localizedDescription)
            }
            
            self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: nil, message: "Total ability score must be 27!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
  
        }
    }
    
    
}

