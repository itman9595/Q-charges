//
//  MainViewController.swift
//  Tracker iOS
//
//  Created by Muratbek Bauyrzhan on 1/27/18.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet var skview: SKView!
    var locationManager: CLLocationManager!
    var prevLocation: CLLocation?
    var started: Bool!
    var isMoving: Bool = false
    var moveColors = [UIColor.red, .blue, .green]
    var overlayColor: UIColor!
    var timer: Timer!
    var stayTime = 0
    var moveTime = 0
    
    var scene: StarterScene!
    var starterBtn: SKShapeNode!
    var starterBtnColor: UIColor!
    
    var userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiation()
        mapInit()
        askForPermissions()
    }
}
