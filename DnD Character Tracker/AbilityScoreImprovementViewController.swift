//
//  AbilityScoreImprovementViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 10/04/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class AbilityScoreImprovementViewController: UIViewController {
    
    var pointsLeft: Int = 2
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet var abilityButton: [UIButton]!
    @IBOutlet var modifierLabel: [UILabel]!
    @IBOutlet var totalAbilityScoreLabel: [UILabel]!
    @IBOutlet weak var abilityNameLabel: UILabel!
    @IBOutlet weak var pointsLeftLabel: UILabel!
    
    var wasModified: [Int] = [0,0,0,0,0,0]
    var stats: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.isHidden = true
        totalAbilityScoreLabel[0].text = stats["CHA"]
        totalAbilityScoreLabel[1].text = stats["CON"]
        totalAbilityScoreLabel[2].text = stats["DEX"]
        totalAbilityScoreLabel[3].text = stats["INT"]
        totalAbilityScoreLabel[4].text = stats["STR"]
        totalAbilityScoreLabel[5].text = stats["WIS"]
    }
    
    @IBAction func selectCHA(_ sender: Any) {
          abilitySelected(index: 0)
          abilityNameLabel.text = "CHA"
      }
      
      @IBAction func selectCon(_ sender: Any) {
          abilitySelected(index: 1)
        abilityNameLabel.text = "CON"

      }
      
      @IBAction func selectDEX(_ sender: Any) {
          abilitySelected(index: 2)
        abilityNameLabel.text = "DEX"

      }
      
      @IBAction func selectINT(_ sender: Any) {
          abilitySelected(index: 3)
        abilityNameLabel.text = "INT"
      }
      
      @IBAction func selectSTR(_ sender: Any) {
          abilitySelected(index: 4)
        abilityNameLabel.text = "STR"

      }
      
      @IBAction func selectWIS(_ sender: Any) {
          abilitySelected(index: 5)
        abilityNameLabel.text = "WIS"

      }
      
      func abilitySelected(index: Int) {
        warningLabel.isHidden = true
          abilityButton[index].isSelected = !abilityButton[index].isSelected
          if(abilityButton[index].isSelected){
              for i in 0...5 {
                  if abilityButton[i].isSelected && i != index {
                      abilityButton[i].isSelected = false
                  }
              }
          }
          else {
              for i in 0...5 {
                  if abilityButton[i].isSelected && i != index {
                      abilityButton[i].isSelected = true
                  }
              }
          }
      }
    
    
    @IBAction func didPressIncreaseScore(_ sender: UIButton) {
          for i in 0...5 {
              if abilityButton[i].isSelected {
                  let index = abilityButton[i].tag
                  guard let currentScore = Int(totalAbilityScoreLabel[index].text!) else { return }
                  if currentScore < 20 && pointsLeft > 0 {
                     totalAbilityScoreLabel[index].text = String(currentScore+1)
                     pointsLeft = pointsLeft - 1
                    pointsLeftLabel.text = "Points left: \(pointsLeft)"
                    wasModified[i] = wasModified[i] + 1
                  } else {
                    warningLabel.isHidden = false
                }
              }
          }
          calculateModifier()

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
              if modifier > 0 {
                 modifierLabel[i].text = "+\(modifier)"
              } else {
                  modifierLabel[i].text = String(modifier)
              }
          }
      }

    
    @IBAction func didPressConfirm(_ sender: Any) {
    }
    
    @IBAction func didPressResetButton(_ sender: Any) {
        pointsLeft = 2
        pointsLeftLabel.text = "Points left: \(pointsLeft)"

        for i in 0...5 {
            if wasModified[i] != 0 {
                guard let currentScore = Int(totalAbilityScoreLabel[i].text!) else { return }
                totalAbilityScoreLabel[i].text = String(currentScore-wasModified[i])
                wasModified[i] = 0
                     }
             }
             calculateModifier()
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
