//
//  MainViewController.swift
//  Tracker macOS
//
//  Created by Muratbek Bauyrzhan on 1/27/18.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Cocoa
import SceneKit

class MainViewController: NSViewController {
    
    override func viewDidLoad() {
        @IBOutlet weak var mapView: MKMapView!
        super.viewDidLoad()
        
    }
}
@IBOutlet weak var mapView: MKMapView!
