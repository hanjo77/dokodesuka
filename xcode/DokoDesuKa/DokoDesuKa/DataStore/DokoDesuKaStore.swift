//
//  BuzzwordStore.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 07.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation
import UIKit

protocol DokoDesuKaStore {
    func allLocations() -> [Location]
    func allUsers() -> [User]
    func userById(id:NSNumber) -> User
    func saveLocation(location: Location)
    func deleteLocation(location:Location)
    func saveUser(user: User)
    func syncLocations(locations: [Location])
    func syncUsers(users: [User])
    func loadImage(url:String) -> UIImage
}
