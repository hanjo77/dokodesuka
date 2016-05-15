//
//  UserEntity+CoreDataProperties.swift
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

extension UserEntity {

    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var id: NSNumber?
    @NSManaged var lastName: String?
    @NSManaged var userName: String?
    @NSManaged var locations: NSSet?

}
