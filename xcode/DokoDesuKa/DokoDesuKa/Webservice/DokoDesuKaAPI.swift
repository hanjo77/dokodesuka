import Foundation
import UIKit


class DokoDesuKaAPI {
    
    let connector:APIConnector
    let targetUrl = "http://46.101.17.239/data/"
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    convenience init () {
        self.init(connector:APIConnector())
    }
    
    init(connector:APIConnector) {
        self.connector = connector
    }
    
    func user(representation:[String: AnyObject]) -> User {
        return User(id:representation["id"] as! Int,
                    userName: representation["username"] as! String,
                    email: representation["email"] as! String,
                    firstName: representation["first_name"] as! String,
                    lastName: representation["last_name"] as! String)
    }
    
    func location(representation:[String: AnyObject]) -> Location {
        let userObj = (representation["created_user"] as! [String: AnyObject])
        let dateString = (representation["date_created"] as? String)!
        let location = Location(id:representation["id"] as! Int,
                                title: representation["title"] as! String,
                                description: representation["description"] as! String,
                                latitude: representation["latitude"] as! Float,
                                longitude: representation["longitude"] as! Float,
                                image: representation["picture"] as! String,
                                users: [User](),
                                createdUser: self.user(userObj),
                                createdDate: dateString.toDateTime())
        return location
    }
    
    func createUser(userName: String, email: String, firstName: String, lastName: String, password: String, completion:APIResult<User> -> Void) {
        connector.performRequest(targetUrl+"add_user", method: "POST", body: [
            "user_name": userName,
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password
        ]) { result in
            switch(result) {
            case .Success(let responseObject):
                let user = self.user(responseObject as! [String:AnyObject])
                completion(.Success(user))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func loadUser(id: Int, completion:APIResult<User> -> Void) {
        connector.performRequest(targetUrl+"load_user", method: "POST", body: [
            "id": id
        ]) { result in
            switch(result) {
            case .Success(let responseObject):
                let user = self.user(responseObject as! [String:AnyObject])
                completion(.Success(user))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func saveLocation(id:Int, title: String, description: String, image: UIImage?, latitude: Float, longitude: Float, completion:APIResult<Location> -> Void) {
        connector.performRequest(targetUrl+"add_location", method: "POST", body: [
            "id": id,
            "title": title,
            "description": description,
            "latitude": latitude,
            "longitude": longitude,
            "image": (image == nil ? "" : self.convertImageToBase64(image!)),
            "created_user_id": self.userDefaults.integerForKey("userId")
        ]) { result in
            switch(result) {
            case .Success(let responseObject):
                let location = self.location(responseObject as! [String:AnyObject])
                completion(.Success(location))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func deleteLocation(id:Int, completion:APIResult<Any> -> Void) {
        connector.performRequest(targetUrl+"delete_location", method: "DELETE", body: [
            "id": id,
            "created_user_id": self.userDefaults.integerForKey("userId")
        ]) { result in
            switch(result) {
            case .Success(let responseObject):
                completion(.Success(responseObject))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func loginUser(userName: String, password: String, completion:APIResult<User> -> Void) {
        connector.performRequest(targetUrl+"login", method: "POST", body: [
            "user_name": userName,
            "password": password
        ]) { result in
            switch(result) {
            case .Success(let responseObject):
                let userData:[String:AnyObject] = responseObject as! [String:AnyObject]
                if (userData.keys.contains("error")) {
                    completion(.Failure(userData["error"] as! String))
                }
                else {
                    let user = self.user(userData)
                    completion(.Success(user))
                }
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func allLocations(completion: APIResult<[Location]> -> Void) {
        connector.performRequest(targetUrl+"locations", method: "GET", body: nil) { result in
            switch(result) {
            case .Success(let responseObject):
                var locations = [Location]()
                let locationList = responseObject as! [AnyObject]
                for locationUncasted in locationList {
                    let locationEntry = locationUncasted as! [String: AnyObject]
                    let location = self.location(locationEntry)
                    locations.append(location)
                }
                completion(.Success(locations))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func allUsers(completion: APIResult<[User]> -> Void) {
        connector.performRequest(targetUrl+"users", method: "GET", body: nil) { result in
            switch(result) {
            case .Success(let responseObject):
                var users = [User]()
                let userList = responseObject as! [AnyObject]
                for userUncasted in userList {
                    let userEntry = userUncasted as! [String: AnyObject]
                    let user = self.user(userEntry)
                    users.append(user)
                }
                completion(.Success(users))
            case .Failure(let errorMessage):
                completion(.Failure(errorMessage))
            case .NetworkError(let error):
                completion(.NetworkError(error))
            }
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImageJPEGRepresentation(image, 0.9)
        let base64String = imageData!.base64EncodedStringWithOptions([])
        
        return base64String
        
    }
}