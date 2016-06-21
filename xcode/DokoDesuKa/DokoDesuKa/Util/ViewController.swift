//
//  ViewController.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 07.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation
import UIKit

class ViewController:UIViewController {
    
    let imageHeight = 560
    let imageWidth = 330
    
    func displayAlertWithMessage(message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        super.presentViewController(alert, animated: false, completion: nil)
    }
    
    func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
        var returnImage: UIImage?
        
        var scaleFactor: CGFloat = 1.0
        var scaledWidth = size.width
        var scaledHeight = size.height
        var thumbnailPoint = CGPointMake(0, 0)
        
        if !CGSizeEqualToSize(image.size, size) {
            let widthFactor = size.width / image.size.width
            let heightFactor = size.height / image.size.height
            
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            
            scaledWidth = image.size.width * scaleFactor
            scaledHeight = image.size.height * scaleFactor
            
            if widthFactor > heightFactor {
                thumbnailPoint.y = (size.height - scaledHeight) * 0.5
            } else if widthFactor < heightFactor {
                thumbnailPoint.x = (size.width - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        image.drawInRect(thumbnailRect)
        returnImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return returnImage
    }
    
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

extension NSDate {
    struct Date {
        static let formatterShortDate = NSDateFormatter(dateFormat: "yyyy年MM月dd日")
    }
    var shortDate: String {
        return Date.formatterShortDate.stringFromDate(self)
    }
}

extension String
{
    func toDateTime() -> NSDate
    {
        var _:NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        guard dateFormatter.dateFromString(self) != nil else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter.dateFromString(self)!
        }
        return dateFormatter.dateFromString(self)!
    }
}
