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
    var myTabBarController:TabBarController?
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailDesc: UITextView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tappedCloseDetail(sender: AnyObject) {
        detailView.hidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myTabBarController = self.tabBarController as? TabBarController
        myTabBarController!.selectedLocation = -1
        updateMarkers((myTabBarController?.locations)!)
    }
    
    func updateMarkers(locations: [Location]) {
        let annotations = self.mapView.annotations
        mapView.removeAnnotations(annotations)
        for location:Location in locations {
            let annotation = DetailPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: Double(location.latitude), longitude: Double(location.longitude))
            annotation.title = location.title
            annotation.subtitle = location.description
            annotation.imageName = location.image
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView (mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        let pinView:MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        pinView.pinTintColor = UIColor.redColor()
        pinView.animatesDrop = true
        pinView.canShowCallout = false
        
        return pinView
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
        let annotation:DetailPointAnnotation = view.annotation as! DetailPointAnnotation
        detailView.hidden = false;
        detailTitle.text = (annotation.title)!
        detailDesc.text = (annotation.subtitle)!
        detailImage.image = DokoDesuKaCoreDataStore().loadImage((annotation.imageName)!)
        NSLog("Selected annotation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class DetailPointAnnotation: MKPointAnnotation {
    var imageName: String!
}