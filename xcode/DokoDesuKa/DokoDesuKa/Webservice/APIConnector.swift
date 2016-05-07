//
//  Connector.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 07.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation

class APIConnector {

    let session:NSURLSession
    
    convenience init () {
        self.init(session:NSURLSession.sharedSession())
    }
    
    init(session:NSURLSession) {
        self.session = session
    }
    
    func handleHTTPErrors<T>(httpResponse:NSHTTPURLResponse, completion:APIResult<T> -> Void) {
        if httpResponse.statusCode >= 400 && httpResponse.statusCode < 500 {
            completion(APIResult.Failure("Request Error"))
        } else if httpResponse.statusCode >= 500 && httpResponse.statusCode < 600 {
            completion(APIResult.Failure(String(httpResponse.statusCode)))
        } else {
            completion(APIResult.Failure("Unknown Error"))
        }
    }
    
    func performRequest(URLString:String, method:String, body:AnyObject?, completion: (APIResult<Any>) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: URLString)!)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let HTTPBody = body {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(HTTPBody, options:NSJSONWritingOptions(rawValue: 0))
        }
        let task = session.dataTaskWithRequest(request, completionHandler: { (let data, let response, let error) in
                if let safeError = error {
                    completion(.NetworkError(safeError))
                } else if let httpResponse = response as! NSHTTPURLResponse! {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                        let responseObject: AnyObject?
                        if let safeData = data {
                            responseObject = try? NSJSONSerialization.JSONObjectWithData(safeData, options: NSJSONReadingOptions(rawValue: 0))
                        } else {
                            responseObject = nil
                        }
                        completion(.Success(responseObject))
                    } else {
                        self.handleHTTPErrors(httpResponse, completion: completion)
                    }
                }

        })
        task.resume()
    }
    
}