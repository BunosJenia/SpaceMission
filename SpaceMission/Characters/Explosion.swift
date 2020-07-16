//
//  Explosion.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/15/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class Explosion: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "explosion")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Explosion"
        zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func spawnExplosion(explosionSound: SKAction, spawnPosition: CGPoint, scene: SKScene) {
        let explosion = Explosion()
        
        explosion.position = spawnPosition
        explosion.setScale(0)
        
        scene.addChild(explosion)
        
        explosion.run(.sequence([
            explosionSound,
            .scale(to: 0.8, duration: 0.1),
            .fadeOut(withDuration: 0.1),
            .removeFromParent()
        ]))
    }
}
