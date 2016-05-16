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
    func saveLocation(location: Location)
    func syncLocations(locations: [Location])
    func loadImage(url:String) -> UIImage
}
