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
    var locations:[Location] = DokoDesuKaCoreDataStore().allLocations()
    var myLocations:[Location] = []
    var images = [String:UIImage]()
    var selectedLocation:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocations = locations.filter({ (location:Location) -> Bool in
            return (location.createdUser!.id == 9)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
