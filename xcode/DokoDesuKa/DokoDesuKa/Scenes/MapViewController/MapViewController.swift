//
//  ViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 06.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let webservice = DokoDesuKaAPI(connector: APIConnector())
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func tappedLogOut(sender: AnyObject) {
        // Go to Login Screen & logout
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        let location = "1 Infinity Loop, Cupertino, CA"
        let geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            
            if((error) != nil){
                
                NSLog("Error"+(error?.localizedDescription)!)
            }
                
//            else if let placemark = placemarks?[0] as? CLPlacemark {
//                
//                var placemark:CLPlacemark = placemarks[0] as! CLPlacemark
//                var coordinates:CLLocationCoordinate2D = placemark.location.coordinate
//                
//                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
//                pointAnnotation.coordinate = coordinates
//                pointAnnotation.title = "Apple HQ"
//                
//                self.mapView?.addAnnotation(pointAnnotation)
//                self.mapView?.centerCoordinate = coordinates
//                self.mapView?.selectAnnotation(pointAnnotation, animated: true)
//                
//                NSLog("Added annotation to map view")
//            }
            
        })
    }
    
    func mapView (mapView: MKMapView,
                  viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinView:MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinTintColor = UIColor.redColor()
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        
        return pinView
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
        
        NSLog("Selected annotation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}