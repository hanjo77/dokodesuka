//
//  TextView.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 16.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class TextView: UITextView, UITextViewDelegate {

    var placeholderColor = UIColor.grayColor()
    var mainColor = UIColor.blackColor()
    var placeholderText = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func setPlaceholder(placeholderText:String) {
        self.placeholderText = placeholderText
        updateColor()
    }
    
    func setup(mainColor:UIColor, placeholderText:String, placeholderColor:UIColor) {
        self.placeholderText = placeholderText
        self.placeholderColor = placeholderColor
        self.mainColor = mainColor
        self.font = UIFont(name: "System", size: 180)
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
    
    func textViewDidBeginEditing(textView:UITextView) {
        if (text == placeholderText) {
            text = ""
            textColor = mainColor
        }
    }
    
    func textViewDidEndEditing (textView:UITextView) {
        if (text.isEmpty) {
            textColor = placeholderColor
            text = placeholderText
        }
    }
}