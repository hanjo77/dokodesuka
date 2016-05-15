//
//  AddUserViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 08.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    // let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation?
    var location:Location?
    var myTabBarController:TabBarController?
    
    @IBOutlet var inputTitle: UITextField!
    @IBOutlet var inputDescription: UITextView!
    @IBOutlet var imgImage: UIImageView!
    @IBOutlet var btnSave: UIButton!
    
    @IBAction func tappedCancel(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            imagePicker.modalPresentationStyle = .FullScreen
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        myTabBarController = self.tabBarController as? TabBarController
        if(imagePicker.isBeingDismissed()) {
            NSLog("Dismissed picker")
        }
        else if(myTabBarController!.selectedLocation >= 0 && myTabBarController!.locations?.count > 0) {
            self.location = myTabBarController!.locations![myTabBarController!.selectedLocation]
            inputTitle.text = self.location?.title
            inputDescription.text = self.location?.description
            if ((self.location?.image) != "" && !myTabBarController!.images.keys.contains((self.location?.image)!)) {
                let url = NSURL(string: (self.location?.image)!)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                imgImage.image = UIImage(data: data!)
                myTabBarController?.images[location!.image] = imgImage.image
            }
            else if (myTabBarController!.images.keys.contains((self.location?.image)!)) {
                imgImage.image = myTabBarController?.images[(self.location?.image)!]
            }
        }
        else if (myTabBarController!.selectedLocation < 0) {
            inputTitle.text = ""
            inputDescription.text = ""
            imgImage.image = UIImage(named: "placeholder")
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) { // Updated to current array syntax [AnyObject] rather than AnyObject[]
        currentLocation = locations.last
    }
    
    @IBAction func tappedUpdateImage(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgImage.contentMode = .ScaleAspectFit
            self.imgImage.image = pickedImage
            if (location!.image != "") {
                myTabBarController?.images[location!.image] = pickedImage
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedSave(sender: AnyObject) {
        if (currentLocation != nil) {
            let latitude = Float((currentLocation?.coordinate.latitude)!)
            let longitude = Float((currentLocation?.coordinate.longitude)!)
            webservice.createLocation(inputTitle.text!, description: inputDescription.text!, image: imgImage.image!, latitude: latitude, longitude: longitude){ result in
                switch (result) {
                case .Success(_):
                    self.myTabBarController?.selectedLocation = -1
                    self.myTabBarController?.selectedIndex = 2
                case .Failure(let errorMessage):
                    NSLog(errorMessage)
                case .NetworkError:
                    NSLog(String(result))
                }
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

