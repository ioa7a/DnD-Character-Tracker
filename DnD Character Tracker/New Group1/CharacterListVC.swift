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
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emailName = user?.email!.components(separatedBy: "@")
        characterListTableView.delegate = self
        characterListTableView.dataSource = self
        ref.child("users").child(emailName![0]).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let chNr = Int(value?["character nr"] as! String) ?? 0
            if chNr > 0 {
                for i in 1...chNr {
                    let charData = value?["\(i)"] as? NSDictionary
                    let chRace = charData!["race"] as? String ?? "race"
                    let chClass = charData!["class"] as? String ?? ""
                    let chBg = charData!["background"] as? String ?? ""
                    let chStats = charData!["stats"] as? [String: String] ?? [:]
                    let chLevel = charData!["level"] as? String ?? "1"
                    let exp = charData!["exp"] as? String ?? "0"
                    self.character.append(Character(user: emailName![0], name: "", race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp))
                }
            }
            
            self.characterListTableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.characterListTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return character.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = characterListTableView.dequeueReusableCell(withIdentifier: "characterCell") as? CharacterListTableViewCell {
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CharacterProfileVC") as! CharacterProfileViewController
        vc.isOwnCharacter = true
        vc.raceName = character[indexPath.row].race
        vc.className = character[indexPath.row].charClass
        vc.level = Int(character[indexPath.row].level) ?? 1
        vc.stats = character[indexPath.row].stats ?? [:]
        vc.charNumber = indexPath.row + 1
        vc.background = character[indexPath.row].background
        vc.currentExp = Int(character[indexPath.row].currentExp) ?? 0
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let charToDelete = indexPath.row + 1
            var charNr = 0
            let userName = user?.email!.components(separatedBy: "@")
            ref.child("users").child(userName![0]).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                charNr = Int(value?["character nr"] as! String) ?? 0
                
                if charToDelete == charNr {
                    self.ref.child("users").child(userName![0]).child("\(charNr)").removeValue()
                    self.ref.child("users").child(userName![0]).updateChildValues(["character nr" : "\(charNr-1)"])
                    self.character.remove(at: charToDelete-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    debugPrint("will delete char nr \(charToDelete)")
                    for i in charToDelete..<charNr {
                        var aux: [String: Any] = [:]
                       
                        if let charData1 = value?["\(i)"] as? [String:Any]{
                            
                            debugPrint(charData1)
                            aux = charData1
                            if let charData2 = value?["\(i+1)"] as? [String : Any] {
                                self.ref.child("users").child(userName![0]).child("\(i)").updateChildValues(charData2)
                                debugPrint(charData2)
                            } else {
                                debugPrint("no")
                            }
                            self.ref.child("users").child(userName![0]).child("\(i+1)").updateChildValues(aux)
                        } else {
                            debugPrint("can't show char \(i)")
                        }
                        
                    }
                    self.ref.child("users").child(userName![0]).child("\(charNr)").removeValue()
                    self.ref.child("users").child(userName![0]).updateChildValues(["character nr" : "\(charNr-1)"])
                    self.character.remove(at: charToDelete-1)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
}
