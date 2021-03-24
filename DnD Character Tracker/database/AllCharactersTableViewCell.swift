//
//  AllCharactersTableViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 14/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AllCharactersTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var characterInfo: UILabel!    
    @IBOutlet weak var messageUserButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
