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
    var expandCell: Bool = false
    var indexOfExpandedCell: Int = -1
    var raceIndex: Int = 0;
    var charNumber: Int = 0
    
    
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
                let langArray = languages!["name"] as? [String]
                let bonusLangNr = languages!["bonus_lang"] as? Int
                let modifiers = value?["modifiers"] as? [String: Int]
                let abilities = value?["ability"] as! String?
                let race = Race(index: i, name: name!, size: size!, speed: speed!, languages: langArray ?? [], modifier: modifiers!, ability: abilities ?? "None")
                race.bonusLang = bonusLangNr ?? 0
                self.races.append(race)
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
        races = races.sorted(by: {$0.name! < $1.name!})
        if let cell = raceTableView.dequeueReusableCell(withIdentifier: "raceCell") as? InfoSelectTableViewCell {
            cell.nameLabel?.text = races[indexPath.row].name
            cell.speedLabel?.text = "Speed: \(races[indexPath.row].speed!) feet"
            cell.sizeLabel?.text = "Size: \(races[indexPath.row].size!)"
            cell.languageLabel.text = "Languages: "
            for i in 0 ..< races[indexPath.row].languages!.count {
                cell.languageLabel.text?.append(races[indexPath.row].languages![i])
                if i < races[indexPath.row].languages!.count - 1{
                    cell.languageLabel.text?.append("; ") }
                
            }
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
        if expandCell && indexPath.row == indexOfExpandedCell {
            return 200.0
        }
        return 60.0
    }
    
    @objc func expandInformation(button: UIButton) {
        button.isSelected = !button.isSelected
        indexOfExpandedCell = button.tag
        expandCell = button.isSelected
        self.raceTableView.beginUpdates()
        self.raceTableView.endUpdates()
    }
    
}

