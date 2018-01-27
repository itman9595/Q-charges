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
        if #available(iOS 11.0, *) {
            mapView.register(PinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        
        startTimer()
        updateData()
    }
    
    func startTimer() {
        stayTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
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
            let artwork = Pin(type: "start", coordinate: locations[0].coordinate, width: 30, height: 30, stayTime: 0)
            mapView.addAnnotation(artwork)
        }
        
        if let oldCoordinate = prevLocation {
            let oldCoordinates = oldCoordinate.coordinate
            let newCoordinates = locations[0].coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            self.mapView.add(polyline)
            
            started = true
            updateDistance(prevCoord: oldCoordinate, curCoord: locations[0])
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Pin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func updateData() {
        userDefault.set(0, forKey: "Distance")
        userDefault.set(0, forKey: "AvgSpeed")
        userDefault.set(0, forKey: "MaxSpeed")
        userDefault.set(300, forKey: "MinSpeed")
        userDefault.set(0, forKey: "StayTime")
        userDefault.set(0, forKey: "MoveTime")
    }
    func updateDistance(prevCoord: CLLocation, curCoord: CLLocation) {
        let distance = prevCoord.distance(from: curCoord)
        let prevDIstance = userDefault.value(forKey: "Distance") as? Double
        userDefault.set(prevDIstance! + distance, forKey: "Distance")
    }
    func updateStayTime() {
        let seconds = userDefault.integer(forKey: "StayTime")
        userDefault.set(seconds + stayTime, forKey: "StayTime")
    }
    func updateMoveTime() {
        let seconds = userDefault.integer(forKey: "MoveTime")
        userDefault.set(seconds + moveTime, forKey: "MoveTime")
    }
    
    func checkSpeed() {
        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = locationManager.location!.speed
        speedLabel.text = String(format: "%.0f km/h", userDefault.double(forKey: "MaxSpeed") * 3.6)
        
        if (speed * 3.6 >= 10 && speed * 3.6 <= 40) {
            overlayColor = moveColors[1]
        } else
        if (speed * 3.6 > 40) {
            overlayColor = moveColors[0]
            
        } else {
            overlayColor = moveColors[2]
        }
        
        if (speed == 0) {
            isMoving = false
        } else {
            if (stayTime > 60 && !isMoving) {
                var waitRate = (CGFloat)(stayTime / 60) * 0.3
                if (waitRate > 10) { waitRate = 10 }

                let artwork = Pin(type: "camp", coordinate: (prevLocation?.coordinate)!, width: 30 + waitRate, height: 30 + waitRate, stayTime: stayTime / 60)
                mapView.addAnnotation(artwork)
                
                updateStayTime()
            }
            
            stayTime = 0
            isMoving = true
            calculateSpeed(curSpeed: speed)
        }
    }
    
    func calculateSpeed(curSpeed: CLLocationSpeed) {
        var maxSpeed = userDefault.value(forKey: "MaxSpeed") as? Double
        var minSpeed = userDefault.value(forKey: "MinSpeed") as? Double
        
        if (curSpeed > maxSpeed!) { maxSpeed = curSpeed }
        if (curSpeed < minSpeed! && curSpeed != 0) { minSpeed = curSpeed }
        
        let avgSpeed = (maxSpeed! + minSpeed!) / 2
        userDefault.set(avgSpeed, forKey: "AvgSpeed")
        userDefault.set(maxSpeed, forKey: "MaxSpeed")
        userDefault.set(minSpeed, forKey: "MinSpeed")
    }
    
    @objc func updateTimer() {
        stayTime += 1
        moveTime += 1
        updateMoveTime()
    }
}
