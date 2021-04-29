//
//  CharacterListVC.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 03/10/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class CharacterListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var characterListTableView: UITableView!
    let user = Auth.auth().currentUser
    var ref: DatabaseReference! = Database.database().reference()
    var character: [Character] = []
    var charNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characterListTableView.delegate = self
        characterListTableView.dataSource = self
        character = []
        getCharacterList()
       
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        character = []
//        getCharacterList()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        character = []
//        getCharacterList()
//    }
    
    func getCharacterList() {
        character = []
        let uid = user?.uid
        ref.child("users").child(uid ?? "none").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let chNr = Int(value?["character nr"] as! String) ?? 0
            self.charNumber = chNr
            let username = value?["username"] as? String
            if chNr > 0 {
                for i in 1...chNr {
                    let charData = value?["\(i)"] as? NSDictionary
                    let chName = charData!["name"] as? String ?? "name"
                    let chRace = charData!["race"] as? String ?? "race"
                    let chClass = charData!["class"] as? String ?? ""
                    let chBg = charData!["background"] as? String ?? ""
                    let chStats = charData!["stats"] as? [String: String] ?? [:]
                    let chLevel = charData!["level"] as? String ?? "1"
                    let exp = charData!["exp"] as? String ?? "0"
                    var langs: [String] = []
                    var profs: [String] = []
                    let equip = charData!["equipment"] as? String
                    if let languageArray = charData?["languages"] as? NSArray{
                        for i in languageArray {
                            langs.append(i as! String)
                        }
                    }
                    
                    if let profArray = charData?["proficiencies"] as? NSArray{
                        for i in profArray {
                            profs.append(i as! String)
                        }
                    }
                    self.character.append(Character(userName: username ?? "n/a", userUID: self.user?.uid ?? "none", name: chName, race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp, languages: langs, proficiencies: profs, equipment: equip ?? "none"))
                }
            }
            self.characterListTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = characterListTableView.dequeueReusableCell(withIdentifier: "characterCell") as? CharacterListTableViewCell {
            cell.nameLabel.text = character[indexPath.row].name
            cell.raceLabel.text = character[indexPath.row].race
            cell.classLabel.text = character[indexPath.row].charClass
            cell.bgLabel.text = character[indexPath.row].background + " Background"
            cell.levelLabel.text = "Level " + character[indexPath.row].level 
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabBarController = storyboard?.instantiateViewController(identifier: "CharacterProfileTabBarMenuVC") as! CharacterProfileTabBarMenuVC
        tabBarController.selectedViewController = tabBarController.viewControllers?[0]
        tabBarController.selectedCharacter = character[indexPath.row]
        tabBarController.charNumber = indexPath.row
        let navVC =  tabBarController.viewControllers![0] as! UINavigationController
        let charProfileVC = navVC.topViewController as! CharacterProfileViewController
        let selectedCharacter = character[indexPath.row]
        charProfileVC.stats = selectedCharacter.stats ?? [:]
        charProfileVC.characterName = selectedCharacter.name
        charProfileVC.raceName = selectedCharacter.race.capitalized
        charProfileVC.className = selectedCharacter.charClass.capitalized
        charProfileVC.level = Int(selectedCharacter.level ) ?? 1
        charProfileVC.charNumber = charNumber
        charProfileVC.background = selectedCharacter.background.capitalized
        charProfileVC.currentExp = Int(selectedCharacter.currentExp ) ?? 0
        charProfileVC.languages = selectedCharacter.languages
        charProfileVC.proficiencies = selectedCharacter.proficiencies
        charProfileVC.equipment = selectedCharacter.equipment
        //TO DO: setup stats & abilities VC
        present(tabBarController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let charToDelete = indexPath.row + 1
            var charNr = 0
            let uid = user?.uid
            ref.child("users").child(uid ?? "none").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                charNr = Int(value?["character nr"] as! String) ?? 0
                
                if charToDelete == charNr {
                    self.ref.child("users").child(uid ?? "none").child("\(charNr)").removeValue()
                    self.ref.child("users").child(uid ?? "none").updateChildValues(["character nr" : "\(charNr-1)"])
                    self.character.remove(at: charToDelete-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    for i in charToDelete..<charNr {
                        var aux: [String: Any] = [:]
                        
                        if let charData1 = value?["\(i)"] as? [String:Any]{
                            
                            aux = charData1
                            if let charData2 = value?["\(i+1)"] as? [String : Any] {
                                self.ref.child("users").child(uid ?? "none").child("\(i)").updateChildValues(charData2)
                            }
                            self.ref.child("users").child(uid ?? "none").child("\(i+1)").updateChildValues(aux)
                        }
                    }
                    self.ref.child("users").child(uid ?? "none").child("\(charNr)").removeValue()
                    self.ref.child("users").child(uid ?? "none").updateChildValues(["character nr" : "\(charNr-1)"])
                    self.character.remove(at: charToDelete-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func didPressAddCharacter(_ sender: Any) {
        let characterNameAlert = UIAlertController(title: nil, message: "Choose a name for your character:", preferredStyle: .alert)
        characterNameAlert.addTextField { (textField) in
            textField.placeholder = "Character name"
        }
        characterNameAlert.addAction(UIAlertAction(title: "DONE", style: .default, handler: { [weak characterNameAlert] (_) in
            let textField = characterNameAlert?.textFields![0]
            if let characterName = textField?.text{
                if characterName != ""{
                    var alreadyExists: Bool =  false
                    for i in 0 ..< self.character.count {
                        if self.character[i].name == characterName {
                            alreadyExists = true
                        }
                    }
                    if !alreadyExists {
                    self.ref.child("users").child(self.user!.uid).updateChildValues(["\(self.charNumber+1)/name" : characterName])
                self.performSegue(withIdentifier: "goToCharacterCreation", sender: (Any).self)
                    }
                    else {
                        let nameAlert = UIAlertController(title: nil, message: "You already have a character with that name!", preferredStyle: .alert)
                        nameAlert.addAction(UIAlertAction(title: "OK", style: .cancel , handler: nil))
                        self.present(nameAlert, animated: true, completion: nil)
                    }
                }
            }
        }))
        characterNameAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        present(characterNameAlert, animated: true, completion: nil)
    }
    
    @IBAction func didPressRefreshCharacterList(_ sender: Any) {
        character = []
        getCharacterList()
    }
    
    
}

