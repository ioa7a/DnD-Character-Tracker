//
//  ProficienciesViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 28/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProficienciesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var classSkillsPickerView: UIPickerView!
    @IBOutlet weak var bonusLanguagePickerView: UIPickerView!
    @IBOutlet weak var bonusLanguageLabel: UILabel!
    @IBOutlet weak var classToolsLabel: UILabel!
    @IBOutlet weak var backgroundLanguagesPickerView: UIPickerView!
    @IBOutlet weak var bgLanguageLabel: UILabel!
    @IBOutlet weak var bgSkillsLabel: UILabel!
    @IBOutlet weak var bgToolsLabel: UILabel!
    
    var classSkillsSource: [String] = []
    var classSkillsNumber: Int = 0
    var languageData: [String] = ["Dwarvish", "Elven", "Giant", "Gnomish", "Goblin", "Halfling", "Orc", "Abyssal", "Celestial", "Draconic", "Deep Speech", "Infernal", "Primordial", "Sylvan", "Undercommon"]
    var bgLanguageNumber: Int = 0
    var classIndex: Int = 0
    var bgIndex: Int = 0
    var charNumber: Int = 0
    var raceIndex: Int = 0
    var ref: DatabaseReference = Database.database().reference()
    let user = Auth.auth().currentUser
    var hasDuplicates: Bool = false
    
    var selectedSkills: [String] = []
    var selectedLanguages: [String] = []
    var backgroundSkills: [String] = []
    var backgroundLanguages: [String] = []
    var knownLanguages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classSkillsPickerView.delegate = self
        classSkillsPickerView.dataSource = self
        bonusLanguagePickerView.delegate = self
        bonusLanguagePickerView.dataSource = self
        backgroundLanguagesPickerView.delegate = self
        backgroundLanguagesPickerView.dataSource = self
        
        ref.child("classes").child(String(classIndex)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let proficiencies = value?["proficiencies"] as? NSDictionary {
                let number = Int(proficiencies["number"] as! String)
                let skills = proficiencies["skills"] as! String
                self.classSkillsSource = skills.components(separatedBy: ", ")
                self.classSkillsNumber = number ?? 0
            }
            if let tools = value?["tools"] as? String {
                self.classToolsLabel.text = "Class tools: \(tools)"
            }
            self.classSkillsPickerView.reloadAllComponents()
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("races").child(String(raceIndex)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let languages = value?["language"] as? NSDictionary {
                let number = languages["bonus_lang"] as! Int
                let langName = languages["name"] as! String
                self.knownLanguages = langName.components(separatedBy: ", ") as! [String]
                self.bonusLanguageLabel.text = "Known languages: \(langName). "
                if number > 0 {
                    self.bonusLanguagePickerView.isHidden = false
                    self.bonusLanguageLabel.text?.append("Choose \(number) bonus language:")
                } else {
                    self.bonusLanguagePickerView.isHidden = true
                }
            }
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        ref.child("backgrounds").child(String(bgIndex)).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let languages = Int(value?["languages"] as? String ?? "0") {
                if languages > 0 {
                    self.bgLanguageNumber = languages
                    self.backgroundLanguagesPickerView.isHidden = false
                } else {
                    self.backgroundLanguagesPickerView.isHidden = true
                    self.bgLanguageLabel.text = "Background languages: none."
                    self.bgLanguageNumber = 0
                }
            }
            let skills = value?["skills"] as? String
            let tools = value?["tools"] as? String
            self.bgSkillsLabel.text = "Background skills: \(skills ?? "none")"
            self.backgroundSkills = skills?.components(separatedBy: ", ") as! [String]
            debugPrint("BG skills: \(self.backgroundSkills)")
            self.bgToolsLabel.text = "Background tools: \(tools ?? "none")"
            
            self.backgroundLanguagesPickerView.reloadAllComponents()
            
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch(pickerView.tag) {
            case 0: return bgLanguageNumber
            case 1: return classSkillsNumber
            case 2: return 1
            default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch(pickerView.tag) {
            case 1: return classSkillsSource.count
            case 0,2: return languageData.count
            default: return 0
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = .systemBlue
            switch(pickerView.tag) {
            case 1:
                pickerLabel?.text = classSkillsSource[row]
                if classSkillsNumber > 2 {
                    pickerLabel?.font = UIFont(name: "System", size: 8.0)
                } else {
                    pickerLabel?.font = UIFont(name: "System", size: 12.0)
                }
            case 0, 2:
                pickerLabel?.text = languageData[row]
                pickerLabel?.font = UIFont(name: "System", size: 14.0)
            default:  pickerLabel?.text =  "none"
            }
        }
        return pickerLabel!
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch(pickerView.tag) {
//            //class skills
//        case 1:   selectedSkills.append(classSkillsSource[row])
//            //background
//        case 0: backgroundLanguages.append(languageData[row])
//        case 2:  selectedLanguages.append(languageData[row])
//        default: return
//
//        }
//        debugPrint("Skills: \(selectedSkills) \nLangs: \(selectedLanguages)")
//    }
    
    @IBAction func selectProficiencies(_ sender: Any) {
        selectedLanguages = []
        selectedSkills = []
//        bonusIndex1 = bonusPicker.selectedRow(inComponent: 0)
//        bonusIndex2 = bonusPicker.selectedRow(inComponent: 1)
        if !backgroundLanguagesPickerView.isHidden{
            for i in 0 ..< backgroundLanguagesPickerView.numberOfComponents{
                selectedLanguages.append(languageData[backgroundLanguagesPickerView.selectedRow(inComponent: i)])
                }
            }
        if !bonusLanguagePickerView.isHidden {
            let bonusLang = languageData[bonusLanguagePickerView.selectedRow(inComponent: 0)]
            selectedLanguages.append(bonusLang)
        }
        selectedLanguages.append(contentsOf: knownLanguages)
        
        if !classSkillsPickerView.isHidden {
            for i in 0 ..< classSkillsPickerView.numberOfComponents{
                selectedSkills.append((classSkillsSource[classSkillsPickerView.selectedRow(inComponent: i)]))
            }
        }
            selectedSkills.append(contentsOf: backgroundSkills)
        debugPrint(selectedSkills)
        hasDuplicates = (selectedLanguages.count != Set(selectedLanguages).count) || (selectedSkills.count != Set(selectedSkills).count)
        if hasDuplicates {
            let alert = UIAlertController(title: "", message: "Selected proficiencies must differ.", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        present(alert, animated: true)
        }
        
    }
    
    
    @IBAction func didPressNext(_ sender: Any) {
        
        if hasDuplicates || selectedSkills == [] || selectedLanguages == [] {
            let alert = UIAlertController(title: "", message: "Please select your proficiencies and languages.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                               present(alert, animated: true)
        } else {
            self.ref.child("users").child(user!.uid).updateChildValues(["\(charNumber+1)/proficiencies" : selectedSkills])
            self.ref.child("users").child(user!.uid).updateChildValues(["\(charNumber+1)/languages" : selectedLanguages])
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StatsVC") as! StatsViewController
                  vc.raceIndex = raceIndex
                  present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func didPressPrevButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
