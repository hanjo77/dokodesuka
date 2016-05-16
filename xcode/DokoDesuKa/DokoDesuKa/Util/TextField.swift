//
//  TextField.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 16.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class TextField: UITextField {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }

}
