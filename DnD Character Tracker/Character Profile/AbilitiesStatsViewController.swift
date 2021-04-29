//
//  AbilitiesStatsViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 29/04/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AbilitiesStatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var ref: DatabaseReference = Database.database().reference()
    var charNumber: Int = 0
    let user = Auth.auth().currentUser
    var stats: [String: String] = [:]
    var proficiencies: [String] = []
    var level: Int = 1
    var collectionViewDataSource: [String] = ["Athletics", "Acrobatics", "Sleight of Hand", "Stealth", "Arcana", "History", "Investigation", "Nature", "Religion", "Animal Handling", "Insight", "Medicine", "Perception", "Survival", "Deception", "Intimidation", "Performance", "Persuasion"]
    
    @IBOutlet var abilityScoreLabel: [UILabel]!
    @IBOutlet var abilityModifierLabel: [UILabel]!
    
    @IBOutlet weak var proficienciesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        proficienciesCollectionView.delegate = self
        proficienciesCollectionView.dataSource = self
        abilityScoreLabel[0].text = stats["CHA"]
        abilityScoreLabel[1].text = stats["CON"]
        abilityScoreLabel[2].text = stats["DEX"]
        abilityScoreLabel[3].text = stats["INT"]
        abilityScoreLabel[4].text = stats["STR"]
        abilityScoreLabel[5].text = stats["WIS"]
        getStats()
        calculateModifier()
        
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
    
    //MARK: Calculate/Update Stats
    func calculateModifier(){
        for i in 0...5 {
            var modifier: Int = 0;
            guard let total = Int(abilityScoreLabel[i].text!) else { return }
            if total <= 8 {
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
        if let cell = proficienciesCollectionView.dequeueReusableCell(withReuseIdentifier: "abilityCell", for: indexPath) as? CharacterAbilityCollectionViewCell{
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
    
}
