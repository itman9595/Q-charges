//
//  PinView.swift
//  Tracker iOS
//
//  Created by Sanzhar Burumbay on 27.01.2018.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Foundation
import MapKit

class PinView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let pin = newValue as? Pin else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                    size: CGSize(width: 30, height: 30)))
            mapsButton.setBackgroundImage(UIImage(named: "finish"), for: UIControlState())
            rightCalloutAccessoryView = mapsButton
            
            if let imageName = pin.imageName {
                let pinImage = UIImage(named: imageName)
                let size = CGSize(width: pin.width!, height: pin.height!)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                image = resizedImage
            } else {
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = "\(pin.stayTime!) min"
            detailCalloutAccessoryView = detailLabel
        }
    }
}

