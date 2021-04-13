//
//  GeneralInfoTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 12/04/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class GeneralInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
