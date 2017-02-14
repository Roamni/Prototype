//
//  DownloadTour.swift
//  Roamni
//
//  Created by Zihao Wang on 10/2/17.
//  Copyright © 2017 ROAMNI. All rights reserved.
//

    import Foundation
    import CoreLocation
    
    struct DownloadTour {
        let tourType : String
        let name : String
        let startLocation : CLLocationCoordinate2D
        let endLocation : CLLocationCoordinate2D
        let downloadUrl:String
        let desc : String
        let star : Int
        let length: String
        let difficulty:String
        let uploadUser:String
        let tourId:String
    }

