//
//  Pin.swift
//  Tracker iOS
//
//  Created by Sanzhar Burumbay on 27.01.2018.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let type: String?
    let width: CGFloat?
    let height: CGFloat?
    
    init(type: String, coordinate: CLLocationCoordinate2D, width: CGFloat, height: CGFloat) {
        self.type = type
        self.coordinate = coordinate
        self.width = width
        self.height = height
    
        super.init()
    }
    
    var imageName: String? {
        return type
    }
}
