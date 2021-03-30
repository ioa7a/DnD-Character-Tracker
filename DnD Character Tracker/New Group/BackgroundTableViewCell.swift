//
//  BackgroundTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 09/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class BackgroundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoButton: CustomButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var featureLabel: UILabel!
    
    var shouldShowInfo: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
