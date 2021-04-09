//
//  BackButton.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 09/04/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//


import UIKit

@IBDesignable
class BackButton: UIButton{
    var borderWidth: CGFloat = 0.0
    var borderColor = UIColor.systemBlue.cgColor
    var image = UIImage(named: "arrowshape.turn.up.left")
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.green,for: .normal)
            self.setImage(image, for: .normal)
        }
    }

    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
    
}
