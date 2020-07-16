//
//  Player.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/15/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "shuttle")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Player"
        zPosition = 2
        size = CGSize(width: 150, height: 200)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Player
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Player {
    func setupPlayer(scene: SKScene) {
        self.setNegativePosition(scene)
        
        scene.addChild(self)
    }
    
    func runToEndPoint(_ scene: SKScene) {
        run(.sequence([.moveTo(y: scene.frame.height * 1.2, duration: 1)]))
    }
    
    func runToStartPoint(_ scene: SKScene) {
        self.setNegativePosition(scene)
        //run(.moveTo(y: 0 - size.height, duration: 0.1))
        run(.sequence([.fadeAlpha(to: 0, duration: 0.01), .moveTo(y: 0 - size.height, duration: 0.01), .fadeAlpha(to: 1, duration: 0.01)]))
        
        run(.sequence([.wait(forDuration: 0.5), .moveTo(y: scene.frame.height * 0.2, duration: 0.5)]))
    }
    
    func playerMovement(touch: UITouch, scene: SKScene, gameArea: CGRect) {
        let pointOfTouch = touch.location(in: self)
        let previousPointOfTouch = touch.previousLocation(in: self)
        let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
        let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
        
        position.x += amountDraggedX
        position.y += amountDraggedY
        
        if position.x > gameArea.maxX - size.width / 2 {
            position.x = gameArea.maxX - size.width / 2
        } else if position.x < gameArea.minX + size.width / 2 {
            position.x = gameArea.minX + size.width / 2
        }
        
        if position.y > scene.size.height / 5 {
            position.y = scene.size.height / 5
        } else if position.y < size.height / 2 {
            position.y = size.height / 2
        }
    }
    
    func setNegativePosition(_ scene: SKScene) {
        self.position = CGPoint(x: scene.size.width / 2, y: 0 - size.height)
    }
}
