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
    let mediaUrl = "http://46.101.17.239/media/"
    let defaultUser = User(
        id:0,
        userName:"Anonymous",
        email:"me@localhost",
        firstName:"No",
        lastName:"Name"
    )
    
    convenience init() {
        self.init(context:CoreDataStack.sharedInstance.mainContext)
    }
    
    init(context:NSManagedObjectContext) {
        self.context = context
        
    }
    
    func getDocUrl() -> NSURL? {
        return try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
    func saveImage(url:String, imageData:NSData) {
        if let image = UIImage(data: imageData) {
            let fileURL = getDocUrl()!.URLByAppendingPathComponent(url)
            if let jpgImageData = UIImageJPEGRepresentation(image, 0.9) {
                jpgImageData.writeToURL(fileURL, atomically: false)
            }
        }
    }
    
    func loadImage(url:String)->UIImage {
        var img:UIImage
        img = UIImage(contentsOfFile: self.getDocUrl()!.URLByAppendingPathComponent(url).path!)!
        return img
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: String, locationEntity: LocationEntity){
        getDataFromUrl(NSURL(string:mediaUrl+url)!) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                locationEntity.image = url
                self.saveImage(url, imageData: data)
            }
        }
    }
    
    func userEntityById(id:NSNumber) -> UserEntity {
        let fetchRequest = NSFetchRequest(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [UserEntity]
        if (entities.count > 0) {
            return entities[0]
        }
        return NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: self.context) as! UserEntity
    }
    
    func userById(id:NSNumber) -> User {
        let entity = userEntityById(id)
        if (entity.id?.integerValue <= 0) {
            return defaultUser
        }
        return User(
            id:Int(entity.id!),
            userName:entity.userName!,
            email:entity.email!,
            firstName:entity.firstName!,
            lastName:entity.lastName!
        )
    }
    
    func deleteLocation(location:Location) {
        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %ld", location.id)
        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
        for entity in entities {
            self.context.deleteObject(entity)
        }
    }
    
    func allLocations() -> [Location] {
        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true),
            // NSSortDescriptor(key: "name", ascending: true),
        ]
        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
        var locations = [Location]()
        for entity in entities {
            let location = Location(
                id:Int(entity.id!),
                title:entity.title!,
                description:entity.desc!,
                latitude:Float(entity.latitude!),
                longitude:Float(entity.longitude!),
                image:entity.image!,
                users: [User](),
                createdUser: (Int(entity.createdUser!) > 0 ? userById(entity.createdUser!) : nil),
                createdDate: ((entity.createdDate != nil) ? entity.createdDate! : nil)
            )
            locations.append(location)
            downloadImage(entity.image!, locationEntity: entity)
        }
        return locations
    }
    
    func allUsers() -> [User] {
        let fetchRequest = NSFetchRequest(entityName: "UserEntity")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true),
            // NSSortDescriptor(key: "name", ascending: true),
        ]
        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [UserEntity]
        var users = [User]()
        for entity in entities {
            let user = User(
                id:Int(entity.id!),
                userName:entity.userName!,
                email:entity.email!,
                firstName:entity.firstName!,
                lastName:entity.lastName!
            )
            users.append(user)
        }
        return users
    }
    
    func saveLocation(location: Location) {
        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %ld", location.id)
        let entities = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
        
        let entity:LocationEntity
        if entities.count > 0 {
            entity = entities[0]
        } else {
            entity = NSEntityDescription.insertNewObjectForEntityForName("LocationEntity", inManagedObjectContext: self.context) as! LocationEntity
        }
        
        entity.id = location.id
        entity.title = location.title
        entity.desc = location.description
        entity.latitude = location.latitude
        entity.longitude = location.longitude
        entity.image = location.image
        entity.createdUser = location.createdUser!.id
        entity.createdDate = location.createdDate
        downloadImage(location.image, locationEntity: entity)
        try! context.save()
    }
    
    func saveUser(user: User) {
        let entity = userEntityById(user.id)
        entity.id = user.id
        entity.userName = user.userName
        entity.email = user.email
        entity.firstName = user.firstName
        entity.lastName = user.lastName
        try! context.save()
    }
    
    func syncLocations(locations: [Location]) {
        let idsToKeep = locations.map() {location in return location.id}
        let fetchRequest = NSFetchRequest(entityName: "LocationEntity")
        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", idsToKeep)
        let entitesToRemove = try! self.context.executeFetchRequest(fetchRequest) as! [LocationEntity]
        for entity in entitesToRemove {
            self.context.deleteObject(entity)
        }
        for location in locations {
            self.saveLocation(location)
        }
    }
    
    func syncUsers(users: [User]) {
        let idsToKeep = users.map() {user in return user.id}
        let fetchRequest = NSFetchRequest(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", idsToKeep)
        let entitesToRemove = try! self.context.executeFetchRequest(fetchRequest) as! [UserEntity]
        for entity in entitesToRemove {
            self.context.deleteObject(entity)
        }
        for user in users {
            self.saveUser(user)
        }
    }
}
