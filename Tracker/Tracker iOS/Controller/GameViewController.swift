//
//  GameViewController.swift
//  Tracker iOS
//
//  Created by Muratbek Bauyrzhan on 1/27/18.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var timer: Timer!
    let defaults = UserDefaults()

    @IBOutlet var gameView: SCNView!
    
    @IBOutlet var distance: UILabel!
    @IBOutlet var avgSpeed: UILabel!
    @IBOutlet var maxSpeed: UILabel!
    @IBOutlet var minSpeed: UILabel!
    @IBOutlet var stayTime: UILabel!
    @IBOutlet var moveTime: UILabel!
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        
        // Allow the user to manipulate the camera
        self.gameView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        self.gameView.backgroundColor = UIColor.init(red: 51/255, green: 153/255, blue: 1.0, alpha: 1.0)
        
        // Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        var gestureRecognizers = gameView.gestureRecognizers ?? []
        gestureRecognizers.insert(tapGesture, at: 0)
        self.gameView.gestureRecognizers = gestureRecognizers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    @objc
    func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        // Highlight the tapped nodes
        let p = gestureRecognizer.location(in: gameView)
        gameController.highlightNodes(atPoint: p)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @objc func updateTimer() {
        
        distance.text = "Distance: \(defaults.integer(forKey: "Distance")) m"
        avgSpeed.text = "Avg Speed: \(defaults.integer(forKey: "AvgSpeed")*Int(3.6)) km/h"
        maxSpeed.text = "Max Speed: \(defaults.integer(forKey: "MaxSpeed")*Int(3.6)) km/h"
        minSpeed.text = "Min Speed: \(defaults.integer(forKey: "MinSpeed")*Int(3.6)) km/h"
        stayTime.text = "Stay Time: \(defaults.integer(forKey: "StayTime")) s"
        moveTime.text = "Move Time: \(defaults.integer(forKey: "MoveTime")) s"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
