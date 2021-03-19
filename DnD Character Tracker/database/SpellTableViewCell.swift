//
//  SpellTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 10/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class SpellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var spellNameLabel: UILabel!
    @IBOutlet weak var classesLabel: UILabel!
    @IBOutlet weak var infoButton: CustomButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        infoButton.isSelected = false
    }

}
