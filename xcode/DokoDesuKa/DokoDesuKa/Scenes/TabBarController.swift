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
    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    var user:User?
    var locations:[Location] = [Location]()
    var myLocations:[Location] = []
    var images = [String:UIImage]()
    var selectedLocation:Int = -1
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func syncLocations() {
        locations = self.store.allLocations()
        myLocations = (locations.filter({ (location:Location) -> Bool in
            let userId = userDefaults.integerForKey("userId");
            return (location.createdUser!.id == userId)
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = userDefaults.integerForKey("userId");
        myLocations = (locations.filter({ (location:Location) -> Bool in
            return (location.createdUser!.id == userId)
        }))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncLocations()
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
