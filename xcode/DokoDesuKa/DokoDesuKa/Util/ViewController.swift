//
//  ViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 07.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation
import UIKit

class ViewController:UIViewController {
    
    var keyboardVisible:Bool = false;
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func keyboardWillShow(sender: NSNotification) {
        if !keyboardVisible {
            if let userInfo = sender.userInfo {
                if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                    animateViewMoving(true, moveValue: keyboardHeight)
                    keyboardVisible = true
                }
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if keyboardVisible {
            if let userInfo = sender.userInfo {
                if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                    animateViewMoving(false, moveValue: keyboardHeight)
                    keyboardVisible = false
                }
            }
        }
    }
}