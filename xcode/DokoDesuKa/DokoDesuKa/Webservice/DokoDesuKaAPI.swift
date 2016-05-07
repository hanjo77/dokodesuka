import Foundation



class DokoDesuKaAPI {
    
    let connector:APIConnector
    let targetUrl = "http://46.101.17.239/data/"
    
    convenience init () {
        self.init(connector:APIConnector())
    }
    
    init(connector:APIConnector) {
        self.connector = connector
    }
    
    func user(representation:[String: AnyObject]) -> User {
        return User(id:representation["id"] as! Int,
                    userName: representation["user_name"] as! String,
                    email: representation["email"] as! String,
                    firstName: representation["first_name"] as! String,
                    lastName: representation["last_name"] as! String)
    }
    
    func location(representation:[String: AnyObject]) -> Location {
        return Location(id:representation["id"] as! Int,
                    title: representation["title"] as! String,
                    description: representation["description"] as! String,
                    latitude: representation["latitude"] as! Float,
                    longitude: representation["longitude"] as! Float,
                    users: representation["users"] as! [User],
                    createdUser: representation["created_user"] as! User,
                    createdDate: representation["created_date"] as! NSDate)
    }
    
    func createUser(userName: String, email: String, firstName: String, lastName: String, completion:APIResult<User> -> Void) {
        connector.performRequest(targetUrl, method: "POST", body: [
            "user_name": userName,
            "email": email,
            "first_name": firstName,
            "last_name": lastName
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
        connector.performRequest(targetUrl, method: "GET", body: nil) { result in
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
    
    func saveUser(user: User, completion: (APIResult<Any>)->Void) {
        let jsonBody = [
            "id":user.id,
            "user_name":user.userName,
            "email":user.email,
            "first_name":user.firstName,
            "last_name":user.lastName]
        connector.performRequest("https://buzzword.com/buzzwords/\(user.id)/", method: "PUT", body: jsonBody, completion: completion)
    }
}