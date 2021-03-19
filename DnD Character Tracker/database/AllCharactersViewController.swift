//
//  AllCharactersViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 14/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class AllCharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var characterTableView: UITableView!
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference! = Database.database().reference()
    var userList: [String] = []
    var allCharactersList: [Character] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailName = user?.email!.components(separatedBy: "@")
        
        characterTableView.delegate = self
        characterTableView.dataSource = self
        searchBar.delegate = self
        
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for (key, _) in value! {
                if let stringKey = key as? String, stringKey != emailName?[0] {
                    self.userList.append(stringKey)
                }
            }
            debugPrint(self.userList)
            for i in 0 ..< self.userList.count {
                self.ref.child("users").child(self.userList[i]).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let chNr = Int(value?["character nr"] as! String) ?? 0
                    if chNr > 0 {
                        for j in 1 ... chNr {
                            let charData = value?["\(j)"] as? NSDictionary
                            let chRace = charData!["race"] as? String ?? "race"
                            let chClass = charData!["class"] as? String ?? ""
                            let chBg = charData!["background"] as? String ?? ""
                            let chStats = charData!["stats"] as? [String: String] ?? [:]
                            let chLevel = charData!["level"] as? String ?? "1"
                            let exp = charData!["exp"] as? String ?? "0"
                            self.allCharactersList.append(Character(user: self.userList[i], name: "", race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp))
                            
                            
                        }
                    }
                    
                
                        self.characterTableView.reloadData()
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    //                 let chNr = Int(value?["character nr"] as! String) ?? 0
    //                 if chNr > 0 {
    //                     for i in 1...chNr {
    //                         let charData = value?["\(i)"] as? NSDictionary
    //                         let chRace = charData!["race"] as? String ?? "race"
    //                         let chClass = charData!["class"] as? String ?? ""
    //                         let chBg = charData!["background"] as? String ?? ""
    //                         let chStats = charData!["stats"] as? [String: String] ?? [:]
    //                         let chLevel = charData!["level"] as? String ?? "1"
    //                         let exp = charData!["exp"] as? String ?? "0"
    //     self.character.append(Character(user: emailName![0], name: "", race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp))
    //}
    //       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCharactersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = characterTableView.dequeueReusableCell(withIdentifier: "characterListCell") as? AllCharactersTableViewCell {
            cell.userNameLabel.text = "User: " + allCharactersList[indexPath.row].user
            cell.characterInfo.text = allCharactersList[indexPath.row].race
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CharacterProfileVC") as! CharacterProfileViewController
            vc.isOwnCharacter = false
        vc.raceName = allCharactersList[indexPath.row].race.capitalized
        vc.className = allCharactersList[indexPath.row].charClass.capitalized
            vc.level = Int(allCharactersList[indexPath.row].level) ?? 1
            vc.stats = allCharactersList[indexPath.row].stats ?? [:]
        vc.background = allCharactersList[indexPath.row].background.capitalized
        present(vc, animated: true, completion: nil)
    }
    
    
}
