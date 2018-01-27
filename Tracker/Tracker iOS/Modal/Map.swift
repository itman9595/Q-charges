//
//  Map.swift
//  Tracker iOS
//
//  Created by Sanzhar Burumbay on 27.01.2018.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension MainViewController: CLLocationManagerDelegate,MKMapViewDelegate {
    
    func mapInit() {
        started = false
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self
    
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
    }
    
    func askForPermissions() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkSpeed()
        
        if (!started) {
            let artwork = Pin(type: "start", coordinate: locations[0].coordinate)
            if #available(iOS 11.0, *) {
                mapView.register(PinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            } else {
                // Fallback on earlier versions
            }
            mapView.addAnnotation(artwork)
        }
        
        if let oldCoordinate = prevLocation {
            let oldCoordinates = oldCoordinate.coordinate
            let newCoordinates = locations[0].coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            self.mapView.add(polyline)
            
            started = true
        }
        
        prevLocation = locations[0]
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = overlayColor
            pr.lineWidth = 5
            return pr
        } else {
            return MKOverlayRenderer()
        }
    }
    
    func checkSpeed() {
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = locationManager.location!.speed
        speedLabel.text = String(format: "%.0f km/h", speed * 3.6)
        
        if (speed * 3.6 >= 10 && speed * 3.6 <= 40) {
            overlayColor = moveColors[1]
        } else
        if (speed * 3.6 >= 60) {
            overlayColor = moveColors[0]
            
        } else {
            overlayColor = moveColors[2]
        }
    }
}
