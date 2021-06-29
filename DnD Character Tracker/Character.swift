//
//  Character.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 31/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import Foundation

struct Character: Equatable {
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
    
    static func == (lhs:Character, rhs:Character) -> Bool {
        return (lhs.name == rhs.name && lhs.race == rhs.race && lhs.charClass == rhs.charClass && lhs.background == rhs.background)
        
    }
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

struct ClassDetails  {
    var name: String?
    var hit_die: String?
    var proficiencies: [String:String]
    var savingThrows: String? = ""
    var armor: String? = ""
    var weapons: String? = ""
    var tools:String? = ""
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
