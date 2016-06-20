//
//  AddUserViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 08.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var currentLocation:CLLocation?
    var location:Location?
    var myTabBarController:TabBarController?
    let addText = "Add location"
    let editText = "Edit location"
    var updatedImage = false
    
    @IBOutlet var inputTitle: UITextField!
    @IBOutlet var inputDescription: UITextView!
    @IBOutlet var imgImage: UIImageView!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet weak var btnUpdatePicture: UIButton!
    @IBOutlet weak var loaderView: UIView!    
    @IBAction func tappedCancel(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.tabBarController?.selectedIndex = 2
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
            imagePicker.allowsEditing = true
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
        super.viewWillAppear(animated)
        btnUpdatePicture.hidden = false;
        self.location = nil
        if (imagePicker.isBeingDismissed()) {
            updatedImage = true
        }
        myTabBarController = self.tabBarController as? TabBarController
        if(myTabBarController!.selectedLocation >= 0 && myTabBarController!.myLocations.count > 0) {
            self.location = myTabBarController!.myLocations[myTabBarController!.selectedLocation]
            if(!imagePicker.isBeingDismissed()) {
                inputTitle.text = self.location?.title
                inputDescription.text = self.location?.description
                if ((self.location?.image) != "") {
                    imgImage.image = self.resizeImage(
                        DokoDesuKaCoreDataStore().loadImage((location?.image)!),
                        size: CGSize(width: imageWidth, height: imageHeight))
                }
            }
            btnUpdatePicture.hidden = true;
        }
        else if (myTabBarController!.selectedLocation < 0 && !imagePicker.isBeingDismissed()) {
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
            self.imgImage.image = resizeImage(pickedImage,
                                              size: CGSize(
                                                width: imageWidth,
                                                height: imageHeight))
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tappedSave(sender: AnyObject) {
        // U
        var latitude:Float = 46.7598823
        var longitude:Float = 7.6237494
        
        if (self.location != nil) {
            latitude = (location?.latitude)!
            longitude = (location?.longitude)!
        }
        else if (currentLocation != nil) {
            latitude = Float((currentLocation?.coordinate.latitude)!)
            longitude = Float((currentLocation?.coordinate.longitude)!)
        }
        loaderView.hidden = false
        var id = -1;
        if (self.location != nil && self.location!.id > 0) {
            id = self.location!.id
        }
        var img:UIImage? = nil
        if (self.location == nil) {
            img = imgImage.image
        }
        myTabBarController!.webservice.saveLocation(id, title:inputTitle.text!, description: inputDescription.text!, image: img, latitude: latitude, longitude: longitude){ result in
            switch (result) {
            case .Success(let location):
                if (self.location == nil) {
                    self.location = location
                }
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.myTabBarController?.store.saveLocation(location)
                    if (self.myTabBarController?.selectedLocation > -1) {
                        self.myTabBarController?.locations[(self.myTabBarController?.selectedLocation)!] = location
                    }
                    DokoDesuKaCoreDataStore().saveImage((self.location?.image)!, imageData: UIImageJPEGRepresentation(self.imgImage.image!, 0.9)!)
                    self.myTabBarController?.selectedLocation = -1
                    self.myTabBarController?.selectedIndex = 2
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(result))
            }
            // Hide loading animation
            self.loaderView.hidden = true
        }
    }
}

