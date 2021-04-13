//
//  Character.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 31/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import Foundation

struct Character {
    var userName: String = ""
    var userUID: String = ""
    var name: String = ""
    var race: String = ""
    var charClass: String = ""
    var background: String = ""
    var stats: [String:String]?
    var level: String = "1"
    var currentExp: String = "0"
    var languages: [String] = []
    var proficiencies: [String] = []
    var equipment: String = ""
}

struct Race {
    var index: Int?
    var name: String?
    var size: String?
    var speed: String?
    var languages: String?
    var bonusLang: Int = 0
    var modifier: [String: Int]?
    var ability: String?
    
}

class Stats {
    var CHA: Int = 0
    var CON: Int = 0
    var DEX: Int = 0
    var INT: Int = 0
    var STR: Int = 0
    var WIS: Int = 0
    var other: Int = 0
    
    init(stats: NSDictionary){
        self.CHA = stats["CHA"] as! Int
        self.CON = stats["CON"] as! Int
        self.DEX = stats["DEX"] as! Int
        self.INT = stats["INT"] as! Int
        self.STR = stats["STR"] as! Int
        self.WIS = stats["WIS"] as! Int
        self.other = stats["other"] as! Int

    }
}


class ClassDetails  {
    var name: String?
    var hit_die: String?
    var proficiencies: [String:String]
    var savingThrows: String? = ""
    var armor: String? = ""
    var weapons: String? = ""
    var tools:String? = ""
    
    init(name: String, hit_die: String, proficiencies: [String:String]){
        self.name = name
        self.hit_die = hit_die
        self.proficiencies = proficiencies
    }
}

struct Background {
    var name: String?
    var desc: String?
    var skills: String?
    var tools: String?
    var languageNr: String?
    var equipment: String?
    var feature: String?

}
