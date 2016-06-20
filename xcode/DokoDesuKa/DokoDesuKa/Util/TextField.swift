//
//  TextField.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 16.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    var placeholderColor = UIColor.grayColor()
    var mainColor = UIColor.blackColor()
    var placeholderText = ""
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        updateColor()
        addTarget(self, action: #selector(TextField.textFieldDidBegin(_:)), forControlEvents: UIControlEvents.EditingDidBegin)
        addTarget(self, action: #selector(TextField.textFieldDidEnd(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
    }
    
    func setup(mainColor:UIColor, placeholderText:String, placeholderColor:UIColor) {
        self.placeholderText = placeholderText
        self.placeholderColor = placeholderColor
        self.mainColor = mainColor
        updateColor();
    }
    
    func updateColor() {
        if (text == placeholderText) {
            textColor = placeholderColor
            text = placeholderText
        }
        else {
            textColor = mainColor
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
    }

    func textFieldDidBegin(sender:AnyObject) {
        if (text == placeholderText) {
            text = ""
            textColor = mainColor
        }
    }

    func textFieldDidEnd(sender:AnyObject) {
        if (text == "") {
            text = placeholderText
            textColor = placeholderColor
        }
    }
}
