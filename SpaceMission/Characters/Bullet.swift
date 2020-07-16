//
//  Bullet.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/15/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class Bullet: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "torpedo")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Bullet"
        zPosition = 2
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bullet
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBullet(scene: SKScene, playerNode: Player, bulletSound: SKAction) {
        position = playerNode.position
        
        scene.addChild(self)
        
        self.run(.sequence([bulletSound, .moveTo(y: scene.size.height + self.frame.height, duration: 1), .removeFromParent()]))
    }
}
