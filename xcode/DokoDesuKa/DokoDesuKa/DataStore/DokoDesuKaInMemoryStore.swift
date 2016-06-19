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

    static var users = [User]()
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
    
    func allUsers() -> [User] {
        return DokoDesuKaCoreDataStore().allUsers().sort() {(let first, second) in
            let isBefore: Bool
            if first.userName == second.userName {
                let comparisonResult = first.firstName.localizedCaseInsensitiveCompare(second.firstName)
                isBefore = comparisonResult == NSComparisonResult.OrderedAscending
            } else {
                isBefore = first.userName > second.userName
            }
            return isBefore
        }
    }
    
    func userById(id: NSNumber) -> User {
        return DokoDesuKaCoreDataStore().allUsers().filter({ (user:User) -> Bool in
            return user.id == id;
        }).first!
    }
    
    func locationIndex(location:Location) -> Int? {
        return DokoDesuKaInMemoryStore.locations.indexOf() {existingLocation in
            existingLocation.id == location.id
        }
    }
    
    func userIndex(user:User) -> Int? {
        return DokoDesuKaInMemoryStore.users.indexOf() {existingUser in
            existingUser.id == user.id
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
    
    func deleteLocation(location:Location) {
        DokoDesuKaInMemoryStore.locations.removeAtIndex(self.locationIndex(location)!)
    }
    
    func saveUser(user: User) {
        if let updateIndex = self.userIndex(user) {
            DokoDesuKaInMemoryStore.users.removeAtIndex(updateIndex)
            DokoDesuKaInMemoryStore.users.insert(user, atIndex: updateIndex)
        } else {
            DokoDesuKaInMemoryStore.users.append(user)
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
    
    func syncUsers(users: [User]) {
        // save all users
        for user in users {
            self.saveUser(user)
        }
        
        // remove users not in list
        var removeIndices = [Int]()
        for (i, user) in DokoDesuKaInMemoryStore.users.enumerate() {
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
            DokoDesuKaInMemoryStore.users.removeAtIndex(toRemove)
        }
    }
}