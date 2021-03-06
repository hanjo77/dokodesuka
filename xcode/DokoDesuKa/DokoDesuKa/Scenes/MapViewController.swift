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

class MapViewController: ViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var myTabBarController:TabBarController?
    let markerImage = UIImage(named: "marker")
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailDesc: UILabel!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    @IBAction func tappedCloseDetail(sender: AnyObject) {
        detailView.hidden = true;
        myTabBarController!.selectedLocation = -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTabBarController = self.tabBarController as? TabBarController
        myTabBarController!.selectedLocation = -1
        // Do any additional setup after loading the view.
        self.mapView.delegate = self
        self.mapView.mapType = MKMapType.Hybrid
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        myTabBarController?.selectedIndex = -1
        myTabBarController?.selectedLocation = -1
        myTabBarController?.syncLocations()
        updateMarkers((myTabBarController?.locations)!)
  }
    
    func updateMarkers(locations: [Location]) {
        let annotations = self.mapView.annotations
        let padding = Double(0.03)
        self.mapView.removeAnnotations(annotations)
        var minPos = CLLocationCoordinate2D(latitude: 90, longitude: 180)
        var maxPos = CLLocationCoordinate2D(latitude: -90, longitude: -180)
        for location:Location in locations {
            let annotation = DetailPointAnnotation()
            let coordinate = CLLocationCoordinate2D(
                latitude: Double(location.latitude), longitude: Double(location.longitude))
            annotation.coordinate = coordinate
            if (coordinate.latitude < minPos.latitude) {
                minPos.latitude = coordinate.latitude
            }
            if (coordinate.longitude < minPos.longitude) {
                minPos.longitude = coordinate.longitude
            }
            if (coordinate.latitude > maxPos.latitude) {
                maxPos.latitude = coordinate.latitude
            }
            if (coordinate.longitude > maxPos.longitude) {
                maxPos.longitude = coordinate.longitude
            }
            annotation.title = (location.createdUser?.userName)! + " の " + location.title
            annotation.subtitle = location.createdDate!.shortDate + "\n" + location.description
            annotation.imageName = location.image
            self.mapView.addAnnotation(annotation)
        }
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(
            latitude: minPos.latitude+((maxPos.latitude-minPos.latitude)/2),
            longitude: minPos.longitude+((maxPos.longitude-minPos.longitude)/2)
        )
        if (locations.count > 0) {
            region.span.latitudeDelta = (maxPos.latitude-minPos.latitude)+(2*padding);
            region.span.longitudeDelta = maxPos.longitude-minPos.longitude+(2*padding);
            self.mapView.region = region;
        }
    }
    
    func mapView (mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        let annotationView:MKAnnotationView = MKAnnotationView()
        annotationView.image = markerImage
        annotationView.annotation = annotation
        annotationView.canShowCallout = false
        annotationView.centerOffset = CGPointMake(0.0, -(annotationView.image?.size.height)!/2);
        return annotationView
    }
    
    func mapView(mapView: MKMapView,
                 didSelectAnnotationView view: MKAnnotationView){
        let annotation:DetailPointAnnotation = view.annotation as! DetailPointAnnotation
        detailView.hidden = false;
        detailTitle.text = (annotation.title)!
        detailDesc.text = (annotation.subtitle)!
        detailDesc.sizeToFit()
        detailImage.image = resizeImage(
            DokoDesuKaCoreDataStore().loadImage((annotation.imageName)!),
                size: CGSize(width: imageWidth, height: imageHeight))
    }
    
    func mapView (manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        updateMarkers((myTabBarController?.locations)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class DetailPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

