//
//  LocationListTableViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 13.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class LocationListTableViewController: UITableViewController {

    let store: DokoDesuKaStore = DokoDesuKaCoreDataStore()
    var imageCache = [UIImage]()
    var selectedLocation = -1
    var myTabBarController:TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        automaticallyAdjustsScrollViewInsets = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        myTabBarController = self.tabBarController as? TabBarController
        myTabBarController!.selectedLocation = -1
        if(myTabBarController!.selectedIndex >= 0 && myTabBarController!.locations.count > 0) {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myTabBarController!.locations.count
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, imageView: UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                imageView.image = UIImage(data:data)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        let location = myTabBarController!.locations[indexPath.row]
        cell.labelTitle.text = location.title
        cell.labelDescription.text = location.description
        cell.imgLocation?.image = DokoDesuKaCoreDataStore().loadImage(location.image)
        // downloadImage(NSURL(string: location.image)!, imageView:cell.imgLocation)
        return cell
    }
    
    // Helper function called after file successfully downloaded
    private func doFileDownloaded(fileURL: NSURL, localFilename: String) {
        
        // Do stuff with downloaded image
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            let tabBarController = self.tabBarController  as! TabBarController
            self.selectedLocation = indexPath.row
            tabBarController.selectedLocation = indexPath.row
            tabBarController.selectedIndex = 1
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segAddLocationView" {
            if let svc = segue.destinationViewController as? AddLocationViewController {
                svc.location = myTabBarController?.locations[myTabBarController!.selectedLocation]
            }
        }
    }

}
