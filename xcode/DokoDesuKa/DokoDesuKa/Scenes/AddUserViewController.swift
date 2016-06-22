//
//  AddUserViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 08.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class AddUserViewController: ViewController, UITextFieldDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    // let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    
    
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
    
    @IBAction func inputUsernameChanged(sender: AnyObject) {
        if (inputUsername.text == "") {
            inputUsername.backgroundColor = UIColor.redColor()
        }
        else {
            inputUsername.backgroundColor = UIColor.whiteColor()
        }
    }
    @IBAction func inputEmailChanged(sender: AnyObject) {
        if (inputEmail.text == "") {
            inputEmail.backgroundColor = UIColor.redColor()
        }
        else {
            inputEmail.backgroundColor = UIColor.whiteColor()
        }
    }
    @IBAction func inputPasswordChanged(sender: AnyObject) {
        if (inputPassword.text == "") {
            inputPassword.backgroundColor = UIColor.redColor()
        }
        else {
            inputPassword.backgroundColor = UIColor.whiteColor()
        }
    }
    @IBAction func inputPwdConfirmChanged(sender: AnyObject) {
        if (inputPassword.text != inputPwdRepeat.text) {
            inputPwdRepeat.backgroundColor = UIColor.redColor()
        }
        else {
            inputPwdRepeat.backgroundColor = UIColor.whiteColor()
        }
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
            case .Success(_):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.performSegueWithIdentifier("segLoginView", sender: nil)
                }
            case .Failure(let errorMessage):
                self.displayAlertWithMessage("Please check your input. All fields are mandatory.")
                NSLog(errorMessage)
            case .NetworkError:
                self.displayAlertWithMessage("Network error, please try again later.")
                NSLog(String(result))
            }
        }
    }
}

