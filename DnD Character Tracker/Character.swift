//
//  Character.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 31/12/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import Foundation

class Character {
    var user: String = ""
    var name: String = ""
    var race: String = ""
    var charClass: String = ""
    var background: String = ""
    var stats: [String:String]?
    var level: String = "1"
    var currentExp: String = "0"
    
    init(user: String, name: String, race: String, charClass: String, background: String, stats: [String: String], level: String, currentExp: String){
        self.user = user
 //       self.name = name
        self.race = race
        self.charClass = charClass
        self.background = background
        self.stats = stats
        self.level = level
        self.currentExp = currentExp
    }
}

class Race {
    var index: Int?
    var name: String?
    var size: String?
    var speed: String?
    var languages: [String]?
    var bonusLang: Int = 0
    var modifier: [String: Int]?
    var ability: String?
    
    init(index: Int, name: String, size: String, speed: String, languages: [String], modifier: [String: Int], ability: String?) {
        self.index = index
        self.name = name
        self.size = size
        self.speed = speed
        self.languages = languages
        self.modifier = modifier
        self.ability = ability
        
    }
}

//class CharacterClass {
//    var name: String?
//    var description: String?
//    var spellList: [Spell] = []
//
//
//    init(name: String, description: String) {
//           self.name = name
//           self.description = description
//       }
//    }

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

enum SpellSchool {
    case Conjuration
    case Necromancy
    case Evocation
    case Abjuration
    case Transmutation
    case Divination
    case Enchantment
    case Illusion
}

enum DamageType {
    case Slashing
    case Piercing
    case Bludgeoning
    case Cold
    case Poison
    case Acid
    case Psychic
    case Fire
    case Necrotic
    case Radiant
    case Force
    case Thunder
    case Lightning
}

struct Results: Codable {
    var index: String?
    var name: String?
    var url: String?
}

class ClassDetails  {
    var name: String?
    var hit_die: String?
    var proficiencies: [String:String]
    var savingThrows: String? = ""
    var armor: String? = ""
    var weapons: String? = ""
    var tools:String? = ""
//    var proficiency_choices: ProficiencyChoices?
//    var proficiencies: Proficiencies?
//    var saving_throws: SavingThrow?
//    var starting_equipment: String?
    
    init(name: String, hit_die: String, proficiencies: [String:String]){
        self.name = name
        self.hit_die = hit_die
        self.proficiencies = proficiencies
    }
}



class Background {
    var name: String?
    var desc: String?
    
    init(name: String, desc: String){
        self.name = name
        self.desc = desc
    }
}
