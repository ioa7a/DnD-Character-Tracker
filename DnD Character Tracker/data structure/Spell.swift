//
//  Spell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 10/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import Foundation

struct Spell: Codable, Equatable {
    var name: String
    var desc: String
    var higher_level: String
      var range: String
      var components: String
      var material: String
//    var ritual: String
      var duration: String
//    var concentration: String
      var casting_time: String
      var level: String
//    var school: String
     var dnd_class: String
}
