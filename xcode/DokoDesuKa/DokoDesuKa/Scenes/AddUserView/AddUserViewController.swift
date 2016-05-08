//
//  AddUserViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 08.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController, UITextFieldDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    
    
    @IBOutlet var inputPwdRepeat: UITextField!
    @IBOutlet var inputPassword: UITextField!
    @IBOutlet var inputLastname: UITextField!
    @IBOutlet var inputFirstname: UITextField!
    @IBOutlet var inputEmail: UITextField!
    @IBOutlet var inputUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.performSegueWithIdentifier("segLoginView", sender: nil)
        }
    }
    
    @IBAction func tappedSave(sender: AnyObject) {
        webservice.createUser(inputUsername.text!, email: inputEmail.text!, firstName: inputFirstname.text!, lastName: inputLastname.text!, password: inputPassword.text!){ result in
            switch (result) {
            case .Success(let user):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.performSegueWithIdentifier("segLoginView", sender: nil)
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(result))
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 250)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 250)
    }
    
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
}

