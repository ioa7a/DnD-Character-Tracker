//
//  InfoSelectTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 03/10/2020.
//  Copyright © 2020 Ioana Bojinca. All rights reserved.
//

import UIKit

class InfoSelectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var modifierLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    @IBOutlet weak var traitLabel: UILabel!
    var shouldShowInfo: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        infoButton.layer.cornerRadius = 2.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    


}
