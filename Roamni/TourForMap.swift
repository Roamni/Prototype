//
//  CategoryForMap.swift
//  CategoryForMap
//  This class identifies category`s location for map
//  Created by Michael on 30/08/2016.
//  Copyright © 2016 Michael. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
//CLLocationCoordinate2D type cannot be stored in coredata, so create a CategoryForMap class used to show categories on maps
class TourForMap: NSObject, MKAnnotation {
    var title: String?
    var info: String
    var coordinate: CLLocationCoordinate2D
   
    //initialize categoryformap
    init(title: String, info: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
    
    var subtitle: String? {
        return info
    }
    
    // MARK: - MapKit related methods
    

    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle]
        //let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        var addressDictionary : [String:String]?
        
        if let subtitle = subtitle {
            // The subtitle value used here is a String,
            // so addressDictionary conforms to its [String:String] type
            addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        }
        
        
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }

    

}
