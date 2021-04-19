//
//  RaceVC.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 03/10/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class RaceSelectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var races : [Race] = []
    var didSelectRace: Bool = false
    var ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var generalInfoButton: UIButton!
    @IBOutlet weak var raceTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
//    var expandCell: Bool = false
//    var indexOfExpandedCell: Int = -1
    var raceIndex: Int = 0;
    var charNumber: Int = 0
    var expandCellAt: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        raceTableView.delegate = self
        raceTableView.dataSource = self
        let user = Auth.auth().currentUser
        let uid = user?.uid
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.charNumber = Int(value?["character nr"] as! String) ?? 0
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        for i in 1...9 {
            ref.child("races").child(String(i)).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String
                let size = value?["size"] as? String
                let speed = value?["speed"] as? String
                let languages = value?["language"] as? NSDictionary
                let langArray = languages!["name"] as? String
                let bonusLangNr = languages!["bonus_lang"] as? Int
                let modifiers = value?["modifiers"] as? [String: Int]
                let abilities = value?["ability"] as! String?
                var race = Race(index: i, name: name!, size: size!, speed: speed!, languages: langArray!, modifier: modifiers!, ability: abilities ?? "None")
                race.bonusLang = bonusLangNr ?? 0
                self.races.append(race)
                self.expandCellAt.append(false)
                self.raceTableView.reloadData()
            })
            { (error) in
                print(error.localizedDescription)
            }
        }       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = raceTableView.dequeueReusableCell(withIdentifier: "raceCell") as? InfoSelectTableViewCell {
            cell.nameLabel?.text = races[indexPath.row].name
            cell.speedLabel?.text = "Speed: \(races[indexPath.row].speed!) feet"
            cell.sizeLabel?.text = "Size: \(races[indexPath.row].size!)"
            cell.languageLabel.text = "Languages: \(races[indexPath.row].languages!)"

            if(races[indexPath.row].bonusLang != 0){
                cell.languageLabel.text?.append(". Bonus languages: \(races[indexPath.row].bonusLang)")
            }
            let dict = races[indexPath.row].modifier!
            cell.abilityLabel.text = "Modifiers: "
            
            var bonusText: String = ""
            for (key, value) in dict {
                if(value > 0 && key != "other" ){
                    cell.abilityLabel.text?.append(" \(key): +\(value)   ")
                }
                if(value > 0 && key == "other" ){
                    bonusText = " Bonus modifiers: +\(value)   "
                }
            }
            cell.abilityLabel.text?.append(bonusText)
            cell.traitLabel.text? = "Abilities: \(races[indexPath.row].ability!)"
            cell.infoButton.setTitle("SHOW INFO", for: .normal)
            cell.infoButton.setTitle("HIDE INFO", for: .selected)
            cell.infoButton.tag = indexPath.row
            cell.infoButton.addTarget(self, action: #selector(self.expandInformation(button:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRace = true
        raceIndex = races[indexPath.row].index ?? 1
    }
    
    @IBAction func didPressNextButton(_ sender: Any) {
        if(didSelectRace){
            let user = Auth.auth().currentUser
            self.ref.child("users").child(user!.uid).updateChildValues(["\(charNumber+1)/race" : races[raceIndex-1].name!])
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClassSelectVC") as! ClassSelectVC
            vc.raceIndex = raceIndex
            present(vc, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "", message: "Please select a race for your character.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func didPressPrevButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandCellAt[indexPath.row]{
            if let cell = raceTableView.cellForRow(at: indexPath) as? InfoSelectTableViewCell{
                return cell.abilityLabel.bounds.size.height + 45.0*4.0
            }
            return 200.0
        }
        return 60.0
    }
    
    @objc func expandInformation(button: UIButton) {
        for i in 0 ..< expandCellAt.count {
            if i == button.tag {
                expandCellAt[i].toggle()
                button.isSelected = expandCellAt[i]
            }
        }
        self.raceTableView.beginUpdates()
        self.raceTableView.endUpdates()
      
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            if let vc = segue.destination as? GeneralInfoTableViewController {
                vc.abilityDescription = [["Darkvision", "Ability to see in dim light within 60 ft as if it were bright light, and in Darkness as if it were dim light. Can’t discern color in Darkness, only Shades of Gray."],
                                                  ["Breath Weapon", "Can use an action to exhale destructive energy. See Draconic Ancestry for the size, shape, and damage type of the exhalation."],
                                                  ["Draconic Ancestry", "The type of dragon chosen will determine your breath weapon and damage Resistance. Damage types:\n\n5 by 30 ft. line (DEX. save) \n    Black Dragon/Acid\n    Blue Dragon/Lightning\n    Brass Dragon/Fire\n    Bronze Dragon/Lightning\n     Copper Dragon/Acid\n\n15ft. cone (DEX. save)\n     Gold Dragon/Fire\n     Red Dragon/Fire \n\n15 ft. cone (CON. save)\n     Green Dragon/Poison\n     Silver Dragon/Cold\n     White Dragon/Cold"],
                                                  ["Dwarven Resilience", "Advantage on Saving Throws against poison. Resistance against poison damage."],
                                                  ["Dwarven Combat Training", "Proficiency with the Battleaxe, Handaxe, Light Hammer, and Warhammer."],
                                                  ["Tool Proficiency", "Proficiency with one artisan’s tools of choice: smith’s tools, brewer’s supplies, or mason’s tools."],
                                                  ["Stonecunning", "When making an Intelligence (History) check related to the Origin of stonework, you are considered proficient in the History skill and add double your Proficiency Bonus to the check, instead of your normal Proficiency Bonus."],
                                                  ["Keen Senses", "Proficiency in the Perception skill."],
                                                  ["Fey Ancestry", "Advantage on Saving Throws against being Charmed. Magic can’t put you to sleep."],
                                                  ["Trance", "Instead of sleeping, you can meditate for 4 hours, remaining semi-conscious."],
                                                  ["Gnome Cunning", "Advantage on all Intelligence, Wisdom, and Charisma Saving Throws against magic."],
                                                  ["Skill Versatility", "Proficiency in two skills of your choice."],
                                                  ["Menacing", "Proficiency in the Intimidation skill."],
                                                  ["Relentless Endurance", "When reduced to 0 HP but not killed outright, you can drop to 1 HP instead. You can’t use this feature again until you finish a Long Rest."],
                                                  ["Savage Attacks", "When scoring a critical hit with a melee weapon Attack, you can roll one of the weapon’s damage dice one more time and add it to the extra damage of the critical hit."],
                                                  ["Lucky", "When you roll a 1 on a D20 for an Attack roll, ability check, or saving throw, you can reroll the die and must use the new roll."],
                                                  ["Brave ", "Advantage on Saving Throws against being Frightened."],
                                                  ["Nimbleness", "Can move through the space of any creature that is of a size larger than yours."],
                                                  ["Hellish Resistance ", "Resistance to fire damage."],
                                                  ["Infernal Legacy", "You know the Thaumaturgy cantrip.\nAs of level 3, you can cast the Hellish Rebuke spell as a 2nd-level spell once with this trait and regain the ability to do so when you finish a Long Rest. \nAs of level 5, you can cast the Darkness spell once with this trait and regain the ability to do so when you finish a Long Rest. \nCharisma is your Spellcasting Ability for these Spells."]]
                
            }
        }
     
    }
   
    
}

