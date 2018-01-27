//
//  Pin.swift
//  Tracker iOS
//
//  Created by Sanzhar Burumbay on 27.01.2018.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let type: String?
    let width: CGFloat?
    let height: CGFloat?
    let title: String?
    let stayTime: Int?
    
    init(type: String, coordinate: CLLocationCoordinate2D, width: CGFloat, height: CGFloat, stayTime: Int) {
        self.type = type
        self.coordinate = coordinate
        self.width = width
        self.height = height
        self.title = type
        self.stayTime = stayTime
    
        super.init()
    }
    
    var imageName: String? {
        return type
    }
    
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: title!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
