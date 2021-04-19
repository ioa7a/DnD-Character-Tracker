//
//  CustomButton.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 06/01/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton{
    var borderWidth: CGFloat = 1.0
    var borderColor = UIColor.systemBlue.cgColor
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(.systemBlue,for: .normal)
            self.setTitleColor(.systemBlue,for: .selected)
            self.backgroundColor = .clear
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = UIColor.clear
            showsTouchWhenHighlighted = false
        }
    }
    
    override var isHighlighted: Bool {
          didSet {
              self.backgroundColor = UIColor.clear
              showsTouchWhenHighlighted = false
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
