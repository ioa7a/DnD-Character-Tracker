//
//  GeneralInfoTableViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 06/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class GeneralInfoTableViewController: UITableViewController {
    
    var abilityDescription: [[String]] = [["Darkvision", "Ability to see in dim light within 60 ft as if it were bright light, and in Darkness as if it were dim light. Can’t discern color in Darkness, only Shades of Gray."],
                                          ["Breath Weapon", "Can use an action to exhale destructive energy. See Draconic Ancestry for the size, shape, and damage type of the exhalation."],
                                          ["Draconic Ancestry", "The type of dragon chosen will determine your breath weapon and damage Resistance. Damage types:\n\n5 by 30 ft. line (DEX. save) \n    Black Dragon/Acid\n    Blue Dragon/Lightning\n    Brass Dragon/Fire\n    Bronze Dragon/Lightning\n     Copper Dragon/Acid\n\n15ft. cone (DEX. save)\n     Gold Dragon/Fire\n     Red Dragon/Fire \n\n15 ft. cone (CON. save)\n     Green Dragon/Poison\n     Silver Dragon/Cold\n     White Dragon/Cold"],
                                          ["Dwarven Resilience", "Advantage on Saving Throws against poison. Resistance against poison damage."],
                                          ["Dwarven Combat Training", "Proficiency with the Battleaxe, Handaxe, Light Hammer, and Warhammer."],
                                          ["Tool Proficiency", "Proficiency with one artisan’s tools of choice: smith’s tools, brewer’s supplies, or mason’s tools."],
                                          ["Stonecunning", "When making an Intelligence (History) check related to the Origin of stonework, you are considered proficient in the History skill and add double your Proficiency Bonus to the check, instead of your normal Proficiency Bonus."],
                                          ["Keen Senses", "Proficiency in the Perception skill."],
                                          ["Fey Ancestry", "Advantage on Saving Throws against being Charmed. Magic can’t put you to sleep."],
                                          ["Trance", "Instead of sleeping, you can meditate for 4 hours, remaining semi-conscious."],
                                          ["Gnome Cunning", "Advantage on all Intelligence, Wisdom, and Charisma Saving Throws against magic."],
                                          ["Skill Versatility", "Proficiency in two skills of your choice."],
                                          ["Menacing", "Proficiency in the Intimidation skill."],
                                          ["Relentless Endurance", "When reduced to 0 HP but not killed outright, you can drop to 1 HP instead. You can’t use this feature again until you finish a Long Rest."],
                                          ["Savage Attacks", "When scoring a critical hit with a melee weapon Attack, you can roll one of the weapon’s damage dice one more time and add it to the extra damage of the critical hit."],
                                          ["Lucky", "When you roll a 1 on a D20 for an Attack roll, ability check, or saving throw, you can reroll the die and must use the new roll."],
                                          ["Brave ", "Advantage on Saving Throws against being Frightened."],
                                          ["Nimbleness", "Can move through the space of any creature that is of a size larger than yours."],
                                          ["Hellish Resistance ", "Resistance to fire damage."],
                                          ["Infernal Legacy", "You know the Thaumaturgy cantrip.\nAs of level 3, you can cast the Hellish Rebuke spell as a 2nd-level spell once with this trait and regain the ability to do so when you finish a Long Rest. \nAs of level 5, you can cast the Darkness spell once with this trait and regain the ability to do so when you finish a Long Rest. \nCharisma is your Spellcasting Ability for these Spells."]
        
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        abilityDescription = abilityDescription.sorted{$0[0]<$1[0]}
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilityDescription.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "generalInfoCell", for: indexPath)
        
        cell.textLabel?.text = abilityDescription[indexPath.row][0]
        cell.detailTextLabel?.text = abilityDescription[indexPath.row][1]
        
        return cell
    }
    
    
    
}
