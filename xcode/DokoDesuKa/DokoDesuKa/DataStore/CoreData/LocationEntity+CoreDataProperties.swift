//
//  LocationEntity+CoreDataProperties.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 15.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LocationEntity {

    @NSManaged var createdDate: NSDate?
    @NSManaged var createdUser: NSNumber?
    @NSManaged var desc: String?
    @NSManaged var id: NSNumber?
    @NSManaged var image: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var title: String?
    @NSManaged var users: NSSet?

}
