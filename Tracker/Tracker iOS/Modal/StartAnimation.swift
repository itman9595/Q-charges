//
//  StartAnimation.swift
//  Tracker iOS
//
//  Created by Sanzhar Burumbay on 27.01.2018.
//  Copyright © 2018 Q Charge. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

extension MainViewController {
    
    func initiation() {
        scene = SKScene(fileNamed: "Launcher") as! StarterScene
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        skview.ignoresSiblingOrder = true
        
        createInitialNodes()
        
        // Present the scene
        skview.presentScene(scene)
    }
    
    func createInitialNodes() {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: 150,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        starterBtn = SKShapeNode(path: path)
        starterBtn.lineWidth = 5
        starterBtnColor = UIColor.init(red: 0/255, green: 102/255, blue: 204/255, alpha: 1.0)
        starterBtn.fillColor = starterBtnColor
        starterBtn.strokeColor = .white
        starterBtn.glowWidth = 1
        starterBtn.name = "StartBtn"
        
        scene.addChild(starterBtn)
        
        let starterLbl = SKLabelNode(text: "Start")
        starterLbl.name = "StarterLbl"
        starterLbl.fontName = "HelveticaNeue-Bold"
        starterLbl.fontSize = 60
        starterBtn.addChild(starterLbl)
        starterLbl.verticalAlignmentMode = .center
        starterLbl.horizontalAlignmentMode = .center
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let touchedLocation = touch.location(in: skview)
        let positionInScene: CGPoint = skview.convert(touchedLocation, to: self.scene)
        let touchedNode = scene.atPoint(positionInScene)
        if touchedNode.name == "StartBtn" || touchedNode.parent?.name == "StartBtn" {
            var node = touchedNode
            if touchedNode.parent?.name == "StartBtn" {
                node = touchedNode.parent!
            }
            
            skview.isUserInteractionEnabled = false
            
            let scale = SKAction.scale(to: 10, duration: 0.7)
            self.starterBtn.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.customAction(withDuration: 0.5, actionBlock: {starterBtnNode, elapsedTime in
                self.starterBtn.fillColor = .white
            }
                )]))
            node.run(scale, completion: {
                UIView.animate(withDuration: 0.5, animations: {
                    self.skview.alpha = 0
                } , completion: { stopped in
                    self.skview.isHidden = true
                    node.setScale(2)
                    self.starterBtn.fillColor = self.starterBtnColor
                })
            })
        }
    }
}
