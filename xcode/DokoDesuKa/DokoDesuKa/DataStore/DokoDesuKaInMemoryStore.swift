//
//  DokoDesuKaInMemoryStore.swift
//  SwiftDiver
//
//  Created by Hansjürg Jaggi on 01.03.16.
//  Copyright © 2016 BFH. All rights reserved.
//

import Foundation
import UIKit

class DokoDesuKaInMemoryStore: DokoDesuKaStore {

    static var locations = [Location]()
    
    func allLocations() -> [Location] {
        return DokoDesuKaCoreDataStore().allLocations().sort() {(let first, second) in
            let isBefore: Bool
            if first.title == second.title {
                let comparisonResult = first.description.localizedCaseInsensitiveCompare(second.description)
                isBefore = comparisonResult == NSComparisonResult.OrderedAscending
            } else {
                isBefore = first.title > second.title
            }
            return isBefore
        }
    }
    
    func locationIndex(location:Location) -> Int? {
        return DokoDesuKaInMemoryStore.locations.indexOf() {existingLocation in
            existingLocation.id == location.id
        }
    }

    func loadImage(url:String)->UIImage {
        return UIImage(contentsOfFile: (DokoDesuKaCoreDataStore().getDocUrl()?.URLByAppendingPathComponent(url).absoluteString)!)!
    }
    
    func saveLocation(location: Location) {
        if let updateIndex = self.locationIndex(location) {
            DokoDesuKaInMemoryStore.locations.removeAtIndex(updateIndex)
            DokoDesuKaInMemoryStore.locations.insert(location, atIndex: updateIndex)
        } else {
            DokoDesuKaInMemoryStore.locations.append(location)
        }
    }
    
    func syncLocations(locations: [Location]) {
        // save all users
        for location in locations {
            self.saveLocation(location)
        }
        
        // remove users not in list
        var removeIndices = [Int]()
        for (i, location) in DokoDesuKaInMemoryStore.locations.enumerate() {
            let foundIndex = locations.indexOf() {existingLocation in
                existingLocation.id == location.id
            }
            if foundIndex == nil {
                removeIndices.append(i)
            }
        }
        removeIndices = removeIndices.sort({$1 < $0})
        for toRemove in removeIndices
        {
            DokoDesuKaInMemoryStore.locations.removeAtIndex(toRemove)
        }
    }
}