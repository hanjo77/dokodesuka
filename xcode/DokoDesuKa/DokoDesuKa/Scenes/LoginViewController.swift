//
//  ViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 06.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class LoginViewController: ViewController, UITextFieldDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    let userDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet var inputUsername: UITextField!
    @IBOutlet var inputPassword: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var toggleRememberMe: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webservice.allUsers() { userResult in
            switch (userResult) {
            case .Success(let users):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    for user in users {
                        self.store.saveUser(user)
                    }
                    self.webservice.allLocations() { result in
                        switch (result) {
                        case .Success(let locations):
                            dispatch_async(dispatch_get_main_queue()) {
                                () -> Void in
                                self.store.syncLocations(locations)
                                self.startup()
                            }
                        case .Failure(let errorMessage):
                            NSLog(errorMessage)
                        case .NetworkError:
                            NSLog(String(result))
                        }
                    }
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(userResult))
            }
        }
    }
    
    func startup() {
        let newImg: UIImage? = UIImage(named: "dokodesuka-logo")
        imageView.image = newImg
        inputUsername.delegate = self
        inputPassword.delegate = self
        let userId = userDefaults.integerForKey("userId")
        let rememberMe = userDefaults.boolForKey("rememberMe")
        if (rememberMe && userId > 0) {
            self.performSegueWithIdentifier("segMapView", sender: nil)
        }
        if (!rememberMe) {
            userDefaults.setBool(self.toggleRememberMe.on, forKey: "rememberMe");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toggleRememberMeChanged(sender: AnyObject) {
        self.userDefaults.setBool(toggleRememberMe.on, forKey: "rememberMe");
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
                    self.userDefaults.setInteger(user.id, forKey: "userId")
                    self.performSegueWithIdentifier("segMapView", sender: nil)
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(result))
            }
        }
    }
}

