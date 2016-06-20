//
//  LogoutView.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 20.06.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import UIKit

public class LogoutOverlay{
    
    var overlayView = UIView()
    var viewController = UITabBarController()
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    class var shared: LogoutOverlay {
        struct Static {
            static let instance: LogoutOverlay = LogoutOverlay()
        }
        return Static.instance
    }
    
    func showOverlay(viewController: UITabBarController) {
        
        self.viewController = viewController
        let view = viewController.view
        let bounds = UIScreen.mainScreen().bounds
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        let tabBarHeight = self.viewController.tabBar.bounds.height
        
        overlayView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        overlayView.center = view.center
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10

        let button = UIButton(frame: CGRect(x: 0, y: statusBarHeight, width: 80, height: bounds.height-(tabBarHeight+statusBarHeight)))
        button.backgroundColor = UIColor.init(red: CGFloat(0.8666), green: CGFloat(0.8666), blue: CGFloat(0.8666), alpha: 1)
        button.setTitle("Logout", forState: .Normal)
        button.setTitleColor(UIColor.redColor(), forState: .Normal)
        button.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        
        overlayView.addSubview(button)
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        overlayView.removeFromSuperview()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.userDefaults.setBool(false, forKey: "rememberMe")
            self.userDefaults.setInteger(0, forKey: "userId")
            self.viewController.performSegueWithIdentifier("segLoginView", sender: nil)
        }
    }
}