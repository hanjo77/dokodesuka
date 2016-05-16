//
//  ViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 06.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    let userDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet var inputUsername: UITextField!
    @IBOutlet var inputPassword: UITextField!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        webservice.allLocations() { result in
            switch (result) {
            case .Success(let locations):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    for location in locations {
                        self.store.saveLocation(location)
                    }
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(result))
            }
        }
        let userId = userDefaults.integerForKey("autoLogin")
        if (userId > 0) {
            dispatch_async(dispatch_get_main_queue()) {
                () -> Void in
                self.performSegueWithIdentifier("segMapView", sender: nil)
            }
        }
        super.viewDidLoad()
        let newImg: UIImage? = UIImage(named: "dokodesuka-logo")
        imageView.image = newImg
        inputUsername.delegate = self
        inputPassword.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedAddUser(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.performSegueWithIdentifier("segAddUserView", sender: nil)
        }
    }
    
    func displayAlertWithMessage(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        super.presentViewController(alert, animated: false, completion: nil)
    }
    
    @IBAction func tappedLogin(sender: AnyObject) {
        webservice.loginUser(self.inputUsername.text!, password: self.inputPassword.text!) { result in
            switch (result) {
            case .Success(let user):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.userDefaults.setInteger(user.id, forKey: "autoLogin")
                    self.performSegueWithIdentifier("segMapView", sender: nil)
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

