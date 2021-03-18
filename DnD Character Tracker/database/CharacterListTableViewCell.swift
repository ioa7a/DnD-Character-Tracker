//
//  CharacterListTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 10/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class CharacterListTableViewCell: UITableViewCell {
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var alignLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
