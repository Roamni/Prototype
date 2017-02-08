//
//  Tour.swift
//  Roamni
//
//  Created by Hyman Li on 9/1/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

import Foundation
import CoreLocation

struct Tour {
    let songid: Int
    let category : String
    let name : String
    let locations : CLLocationCoordinate2D
    let desc : String
    let address : String
    let star : String
    let length: String
    let difficulty:String
}
