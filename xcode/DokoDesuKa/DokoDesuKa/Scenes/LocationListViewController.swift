//
//  LocationListViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 14.06.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

class LocationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var imageCache = [UIImage]()
    var locations:[Location]?
    var myTabBarController:TabBarController?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        automaticallyAdjustsScrollViewInsets = true
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        myTabBarController = self.tabBarController as? TabBarController
        self.reloadTable()
    }
    
    func reloadTable() {
        myTabBarController!.selectedLocation = -1
        self.myTabBarController!.syncLocations()
        self.locations = self.myTabBarController?.myLocations
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        let location = locations![indexPath.row]
        cell.labelTitle.text = location.title
        cell.labelDescription.text = location.description
        cell.imgLocation?.image = DokoDesuKaCoreDataStore().loadImage(location.image)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.myTabBarController!.selectedLocation = indexPath.row
            self.myTabBarController!.selectedIndex = 1
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // add the action button you want to show when swiping on tableView's cell , in this case add the delete button.
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action , indexPath) -> Void in
            let deleteLocation = self.locations![indexPath.row]
            self.myTabBarController?.store.deleteLocation(deleteLocation)
            self.reloadTable()
            self.myTabBarController!.webservice.deleteLocation(deleteLocation.id) { responseObject in
                switch (responseObject) {
                case .Success(_):
                    self.tableView.editing=false;
                case .Failure(let errorMessage):
                    NSLog(errorMessage)
                case .NetworkError:
                    NSLog(String(responseObject))
                }
            }
        })
        // You can set its properties like normal button
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction]
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
                svc.location = locations![myTabBarController!.selectedLocation]
            }
        }
    }
}
