//
//  InterfaceController.swift
//  Tracker watchOS App Extension
//
//  Created by Muratbek Bauyrzhan on 1/27/18.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import WatchKit
import SceneKit

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var scnInterface: WKInterfaceSCNScene!
    var gameController: GameController!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        gameController = GameController(sceneRenderer: scnInterface)
    }
    
    func handleTap(_ gestureRecognizer: WKTapGestureRecognizer) {
        // Highlight the tapped nodes
        let p = gestureRecognizer.locationInObject()
        gameController.highlightNodes(atPoint: p)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
