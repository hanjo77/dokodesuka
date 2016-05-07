//
//  APIResult.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 06.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case Success(T)
    case Failure(String)
    case NetworkError(NSError)
}