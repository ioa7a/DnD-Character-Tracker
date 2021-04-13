//
//  ClassVC.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 03/10/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

class ClassSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: DatabaseReference = Database.database().reference()
    var didSelectClass: Bool = false
    var expandCell: Bool = false
    var indexOfExpandedCell: Int = -1
    var raceIndex: Int = 0;
    var classDetailsArray : [ClassDetails] = []
    var charClass: ClassDetails?
    var classIndex: Int = 0
    let user = Auth.auth().currentUser
    var charNumber: Int = 0;
    
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var prevButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classTableView.delegate = self
        classTableView.dataSource = self
        ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.charNumber = Int(value?["character nr"] as! String) ?? 0
        })
        { (error) in
            print(error.localizedDescription)
        }
        
        for i in 1...12 {
            ref.child("classes").child(String(i)).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["name"] as? String
                let hitDie = value?["hitDie"] as? String
                let savingThrows = value?["savingThrows"] as? String
                let proficiencies = value?["proficiencies"] as? [String:String]
                let armor = value?["armor"] as? String
                let weapons = value?["weapons"] as? String
                let tools = value?["tools"] as? String
                let myClass = ClassDetails(name: name ?? "none", hit_die: hitDie ?? "1d8", proficiencies: proficiencies ?? [:])
                myClass.savingThrows = savingThrows
                myClass.armor = armor
                myClass.weapons = weapons
                myClass.tools = tools
                self.classDetailsArray.append(myClass)
                self.classTableView.reloadData()
            })
            { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = classTableView.dequeueReusableCell(withIdentifier: "classCell") as? ClassInfoTableViewCell {
            cell.nameLabel.text = classDetailsArray[indexPath.row].name
            cell.hitDieLabel.text = "Hit dice: " +  String(classDetailsArray[indexPath.row].hit_die!)
            cell.savingThrowsLabel.text = "Saving throws: \(classDetailsArray[indexPath.row].savingThrows ?? "none")"
            cell.proficienciesLabel.text = "Skills: Choose \(classDetailsArray[indexPath.row].proficiencies["number"] ?? "0" ) from \(classDetailsArray[indexPath.row].proficiencies["skills"] ?? "none")"
            cell.armorLabel.text = "Armor: \(classDetailsArray[indexPath.row].armor ?? "Light Armor")"
            cell.weaponsLabel.text = "Weapons: \(classDetailsArray[indexPath.row].weapons ?? "Simple Weapons")"
            cell.toolsLabel.text = "Tools: \(classDetailsArray[indexPath.row].tools ?? "none")"
            cell.infoButton.tag = indexPath.row
            cell.infoButton.setTitle("SHOW INFO", for: .normal)
            cell.infoButton.setTitle("HIDE INFO", for: .selected)
            cell.infoButton.addTarget(self, action: #selector(self.expandInformation(button:)), for: .touchUpInside)
            if indexPath.row != indexOfExpandedCell {
                cell.infoButton.isSelected = false
            }
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        charClass = classDetailsArray[indexPath.row]
        classIndex = indexPath.row + 1
        didSelectClass = true
    }
    
    @IBAction func didpressNextButton(_ sender: Any) {
        if didSelectClass {
            self.ref.child("users").child(user!.uid).updateChildValues(["\(charNumber+1)/class" : charClass!.name ?? "none"])
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "backgroundViewController") as! BackgroundViewController
            vc.raceIndex = raceIndex
            vc.classIndex = classIndex
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "", message: "Please select a class for your character.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandCell && indexPath.row == indexOfExpandedCell {
            if let cell = classTableView.cellForRow(at: indexPath) as? ClassInfoTableViewCell {
                return cell.proficienciesLabel.bounds.size.height + 75.0*5.0
            }
               return 300.0
        }
        return 65.0
    }
    @IBAction func didPressPrevButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func expandInformation(button: UIButton) {
        button.isSelected = !button.isSelected
        indexOfExpandedCell = button.tag
        expandCell = button.isSelected
        self.classTableView.beginUpdates()
        self.classTableView.endUpdates()
    }
    
    
    
}
