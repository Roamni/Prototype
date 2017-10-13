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
        let mode: String
        let name : String
        let startLocation : CLLocationCoordinate2D
        let endLocation : CLLocationCoordinate2D
        let downloadUrl:String
        let desc : String
        var star : Float
        let length: Int
        let difficulty:String
        let uploadUser:String
        let tourId:String
        let price: Float
    }

