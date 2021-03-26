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
    var uidList: [String] = []
    var allCharactersList: [Character] = []
    var currentUserName: String = ""
    
    var selectCell: Bool = false
    var indexOfSelectedCell: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterTableView.delegate = self
        characterTableView.dataSource = self
        searchBar.delegate = self
        getCharacters(filter: "")
        
    }
    
    func getCharacters(filter: String){
        allCharactersList = []
        userList = []
        characterTableView.reloadData()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
             let value = snapshot.value as? NSDictionary
             for (key, val) in value! {
                 if let stringKey = key as? String {
                    if stringKey != self.user!.uid {
                        self.userList.append(stringKey)
//                        if let dictValue = val as? NSDictionary {
//                            self.userList.append(dictValue["username"] as? String ?? "user")
//                                               }
                        
                    }
                    else {
                        if let dictValue = val as? NSDictionary {
                            self.currentUserName = dictValue["username"] as? String ?? "user"
                        }
                     }
                 }
             }
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
                             let textToFilter = "Level \(chLevel) \(chRace) \(chClass)"
                            if filter == "" || (textToFilter.lowercased().contains(filter.lowercased())) {
                             self.allCharactersList.append(Character(user: self.userList[i], name: "", race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp))
                            }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCharactersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = characterTableView.dequeueReusableCell(withIdentifier: "characterListCell") as? AllCharactersTableViewCell {
            cell.userNameLabel.text = "User: " + allCharactersList[indexPath.row].user
            cell.characterInfo.text = "Level \(allCharactersList[indexPath.row].level) \(allCharactersList[indexPath.row].race) \(allCharactersList[indexPath.row].charClass)\n"
            let stats = allCharactersList[indexPath.row].stats
            cell.characterInfo.text?.append("CHA: \(stats?["CHA"] ?? "0")/CON: \(stats?["CON"] ?? "0")/DEX: \(stats?["DEX"] ?? "0")/INT: \(stats?["INT"] ?? "0")/STR: \(stats?["STR"] ?? "0")/WIS: \(stats?["WIS"] ?? "0")")
            cell.messageUserButton.addTarget(self, action: #selector(self.messageUser(button:)), for: .touchUpInside)
            
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func messageUser(button: UIButton) {
         indexOfSelectedCell = button.tag
         selectCell = button.isSelected
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        vc.user2Name = allCharactersList[button.tag].user
        vc.user1Name = currentUserName
        present(vc, animated: true)
     }
     
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        allCharactersList = []
        characterTableView.reloadData()
        let filter = searchBar.text ?? ""
        getCharacters(filter: filter)
    }
    
}
