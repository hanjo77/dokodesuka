//
//  Location.swift
//  DokoDesuKa
//
//  Created by Hansjürg Jaggi on 06.05.16.
//  Copyright © 2016 Hansjürg Jaggi. All rights reserved.
//

import Foundation
import UIKit

struct Location {
    let id:Int
    let title:String
    let description:String
    let latitude:Float
    let longitude:Float
    let image:String
    var users:Array<User>?
    var createdUser:User?
}
