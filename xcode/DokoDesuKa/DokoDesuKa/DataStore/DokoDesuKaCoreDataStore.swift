//
//  DokoDesuKaCoreDataStore.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 07.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DokoDesuKaCoreDataStore:DokoDesuKaStore {
    let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context:CoreDataStack.sharedInstance.mainContext)
    }
    
    init(context:NSManagedObjectContext) {
        self.context = context
        
    }
    
//    func allLocations() -> [Location] {
//        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(key: "count", ascending: false),
//            NSSortDescriptor(key: "name", ascending: true),
//        ]
////        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
////        var locations = [Location]()
////        for entity in entities {
////            locations.append(Location(
////                id:Int(entity.id!),
////                title:entity.title!,
////                description:entity.description,
////                latitude:Float(entity.latitude!),
////                longitude:Float(entity.longitude!),
////                image:UIImage(entity.image),
////                users:Array<User>(),
////                createdUser:(entity.createdUser as! User)
////            ))
////        }
//        return locations
//    }
//    
//    func saveLocation(location: Location) {
//        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
//        fetchRequest.predicate = NSPredicate(format: "id = %ld", location.id)
//        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
//        
//        let entity:LocationEntity
//        if entities.count > 0 {
//            entity = entities[0]
//        } else {
//            entity = NSEntityDescription.insertNewObjectForEntityForName("LocationEntity", inManagedObjectContext: self.context) as! LocationEntity
//        }
//        
//        entity.id = location.id
//        entity.title = location.title
//        entity.desc = location.description
//        entity.latitude = location.latitude
//        entity.longitude = location.longitude
//        entity.image = location.image
//        try! context.save()
//    }
//    
//    func syncLocations(locations: [Location]) {
//        let idsToKeep = locations.map() {location in return location.id}
//        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
//        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", idsToKeep)
//        let entitesToRemove = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
//        for entity in entitesToRemove {
//            self.context.deleteObject(entity)
//        }
//        for location in locations {
//            self.saveLocation(location)
//        }
//    }
}
