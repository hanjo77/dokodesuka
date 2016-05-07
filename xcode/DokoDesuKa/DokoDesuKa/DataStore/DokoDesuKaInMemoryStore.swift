//
//  DokoDesuKaInMemoryStore.swift
//  SwiftDiver
//
//  Created by Hansjürg Jaggi on 01.03.16.
//  Copyright © 2016 BFH. All rights reserved.
//

import Foundation

class DokoDesuKaInMemoryStore: DokoDesuKaStore {

    static var locations = [Location]()
    
    func allLocations() -> [Location] {
        return DokoDesuKaInMemoryStore.locations.sort() {(let first, second) in
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
    
    func saveLocation(location: Location) {
        if let updateIndex = self.locationIndex(location) {
            DokoDesuKaInMemoryStore.locations.removeAtIndex(updateIndex)
            DokoDesuKaInMemoryStore.locations.insert(location, atIndex: updateIndex)
        } else {
            DokoDesuKaInMemoryStore.locations.append(location)
        }
    }
    
    func syncLocations(users: [Location]) {
        // save all users
        for user in users {
            self.saveLocation(user)
        }
        
        // remove users not in list
        var removeIndices = [Int]()
        for (i, user) in DokoDesuKaInMemoryStore.locations.enumerate() {
            let foundIndex = users.indexOf() {existingUser in
                existingUser.id == user.id
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