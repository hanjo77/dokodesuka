//
//  TabBarController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 14.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let webservice = DokoDesuKaAPI(connector: APIConnector())
    var user:User?
    var locations:[Location]?
    var images = [String:UIImage]()
    var selectedLocation:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, imageView:UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                imageView.image = UIImage(data: data)
                self.images[url.absoluteString] = imageView.image
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webservice.allLocations() { result in
            switch (result) {
            case .Success(let locations):
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.locations = locations
                    for location in locations {
                        self.downloadImage(NSURL(string:location.image)!, imageView:UIImageView())
                    }
                }
            case .Failure(let errorMessage):
                NSLog(errorMessage)
            case .NetworkError:
                NSLog(String(result))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
