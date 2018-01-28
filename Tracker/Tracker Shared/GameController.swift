//
//  GameController.swift
//  Tracker Shared
//
//  Created by Muratbek Bauyrzhan on 1/27/18.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import SceneKit

#if os(watchOS)
    import WatchKit
#endif

#if os(macOS)
    typealias SCNColor = NSColor
#else
    typealias SCNColor = UIColor
#endif

class GameController: NSObject, SCNSceneRendererDelegate {

    var scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    
    enum mode {
        case walk
        case car
    }
    
    var motion: mode = .walk
    
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        sceneRenderer = renderer
        scene = SCNScene(named: "Man.dae")!
        
        super.init()
        
        sceneRenderer.delegate = self
        
        sceneRenderer.scene = scene
        
    }
    
    func highlightNodes(atPoint point: CGPoint) {
        let hitResults = self.sceneRenderer.hitTest(point, options: [:])
        for result in hitResults {
            // get its material
            guard let material = result.node.geometry?.firstMaterial else {
                return
            }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = SCNColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = SCNColor.red
            
            SCNTransaction.commit()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        changeMotionMode()
        
        // Called before each frame is rendered
    }
    
    func wipeOutScene() {
        scene.rootNode.removeAllActions()
        scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
    func changeMotionMode() {
        
        let defaults = UserDefaults()
        
        let avgSpeed = defaults.integer(forKey: "AvgSpeed")*Int(3.6)
        
        if avgSpeed < 10 {
            // Walk
            if motion != mode.walk {
                scene = SCNScene(named: "Man.dae")!
                sceneRenderer.scene = scene
            }
            motion = mode.walk
        } else {
            // Car
            if motion != mode.car {
                let car = SCNScene(named: "Car.dae")!
                car.rootNode.enumerateChildNodes { (node, stop) in
                    if node.name == "wheel" {
                        node.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: -20, y: 0, z: 0, duration: 1)))
                    }
                }
                sceneRenderer.scene = car
            }
            motion = mode.car
        }
    }

}
