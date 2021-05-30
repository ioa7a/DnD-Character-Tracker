//
//  ClassInfoTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 06/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class ClassInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hitDieLabel: UILabel!
    @IBOutlet weak var infoButton: CustomButton!
    @IBOutlet weak var savingThrowsLabel: UILabel!
    @IBOutlet weak var proficienciesLabel: UILabel!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var weaponsLabel: UILabel!
    @IBOutlet weak var toolsLabel: UILabel!
    var shouldShowInfo: Bool = false
    @IBOutlet weak var expandedStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoButton.layer.cornerRadius = 2.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
