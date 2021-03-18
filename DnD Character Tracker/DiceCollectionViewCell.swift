//
//  DiceCollectionViewCell.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 05/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

class DiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var resultLabel: UILabel!
    var diceColors: [UIColor] = [UIColor.green, UIColor.blue, UIColor.purple,
                                 UIColor.systemPink, UIColor.red, UIColor.orange]
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        resultLabel.text = "test"
//        resultLabel.backgroundColor = .green
    }
}
