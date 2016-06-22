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
        inputUsername.delegate = self
        inputPassword.delegate = self
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let newImg: UIImage? = UIImage(named: "dokodesuka-logo")
        imageView.image = newImg
    }
    
    func startup() {
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
                self.displayAlertWithMessage("Please check your input.")
                NSLog(errorMessage)
            case .NetworkError:
                self.displayAlertWithMessage("Network error, please try again later.")
                NSLog(String(result))
            }
        }
    }
}

