//
//  ChartsViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 29/05/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    var ref: DatabaseReference! = Database.database().reference()
    var character: [Character] = []
    var races: [String : Int ] = ["Dragonborn": 0, "Dwarf": 0, "Elf" : 0, "Gnome" : 0, "Halfling" : 0,  "Half-Elf" : 0, "Half-Orc" : 0, "Human" : 0, "Tiefling" : 0]
    var classes: [String : Int] = ["Barbarian" : 0 ,"Bard" : 0 , "Cleric" : 0, "Druid" : 0, "Fighter" : 0 ,"Monk" : 0 , "Paladin" : 0, "Ranger" : 0,  "Rogue" : 0 , "Sorcerer" : 0, "Warlock" : 0, "Wizard" : 0]
    var racesPieChart = PieChartView()
    var classesPieChart = PieChartView()

   
    var userList: [UserData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup pie chart
        racesPieChart.delegate = self
        classesPieChart.delegate = self
        racesPieChart.frame = CGRect(x: 0, y: 40.0, width: self.view.frame.width, height: self.view.frame.height/2 - 50.0)
        classesPieChart.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2 - 50.0)
        racesPieChart.isUserInteractionEnabled = false
        classesPieChart.isUserInteractionEnabled = false
        view.addSubview(racesPieChart)
        view.addSubview(classesPieChart)
        
        //retrieve character list & count races
        getUsers{ [self] (success) in
            if success {
                getCharacters{ [self] (success) in
                    if success {
                        for i in 0 ..< self.character.count {
                            self.races[self.character[i].race] =  self.races[self.character[i].race]! + 1
                            self.classes[self.character[i].charClass] =  self.classes[self.character[i].charClass]! + 1

                        }
                        var raceEntries = [ChartDataEntry]()
                        var nr = 0
                        for (key, value) in races {
                            if value != 0{
                                raceEntries.append(PieChartDataEntry(value: Double(value), label: key))
                                nr = nr + 1
                            }
                        }
                        var classEntries = [ChartDataEntry]()
                        nr = 0
                        for (key, value) in classes {
                            if value != 0{
                                classEntries.append(PieChartDataEntry(value: Double(value), label: key))
                                classEntries[nr].accessibilityLabel = key
                                nr = nr + 1
                            }
                        }
                        let set = PieChartDataSet(entries: raceEntries)
                        let set2 = PieChartDataSet(entries: classEntries)
                        set.colors = ChartColorTemplates.pastel()
                        set2.colors = ChartColorTemplates.pastel()
                        
                        let data = PieChartData(dataSet: set)
                        let data2 = PieChartData(dataSet: set2)
                        self.racesPieChart.data = data
                        self.classesPieChart.data = data2
                        racesPieChart.centerText = "char. no. by race"
                        classesPieChart.centerText = "char. no. by class"
                        racesPieChart.entryLabelFont = .boldSystemFont(ofSize: 14)
                        classesPieChart.entryLabelFont = .boldSystemFont(ofSize: 14)
                        racesPieChart.holeColor = .clear
                        classesPieChart.holeColor = .clear
                    }
                }
            }
        }
    }
    
    func getCharacters(success:@escaping (Bool) -> Void) {
        character = []
        for i in 0 ..< self.userList.count {
                self.ref.child("users").child(self.userList[i].uid).observeSingleEvent(of: .value, with: { (snapshot) in
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
                            self.character.append(Character(userName: self.userList[i].username, userUID: self.userList[i].uid, name: "", race: chRace, charClass: chClass, background: chBg, stats: chStats, level: chLevel, currentExp: exp))
                        }
                    }
                    if i == self.userList.count - 1{
                        success(true)
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
    }
    
    func getUsers(success:@escaping (Bool) -> Void) {
        userList = []
        character = []
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for (key, val) in value! {
                if let stringKey = key as? String {
                    if let dictValue = val as? NSDictionary {
                        if let username = dictValue["username"] as? String {
                            self.userList.append(UserData(uid: stringKey, username: username))
                        }
                    }
                }
            }
        success(true)
        }) { (error) in
            print(error.localizedDescription)
        }
    
    }
}

