//
//  Enemy.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/16/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    let firstLevelEnemySpeed = 7
    
    init() {
        let texture = SKTexture(imageNamed: "alien2")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Enemy"
        zPosition = 2
        size = CGSize(width: 150, height: 100)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody!.affectedByGravity = false
        physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Enemy {
    func setupEnemy(_ scene: GameScene) {
        let randomXStart = CGFloat.random(in: scene.gameArea.minX...scene.gameArea.maxX)
        let randomXEnd = CGFloat.random(in: scene.gameArea.minX...scene.gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart, y: scene.gameArea.maxY * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height)
        
        position = startPoint
        
        scene.addChild(self)
        
        self.run(.sequence([.move(to: endPoint, duration: self.getSpeed(scene.levelNumber)), .removeFromParent(), .run(scene.loseALife), .run(scene.reduceEnemyCount)]))
    
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        zRotation = atan2(dy, dx)
    }
    
    func getSpeed(_ levelNumber: Int) -> TimeInterval {
        var timeInterval = self.firstLevelEnemySpeed - levelNumber / 2
        
        if timeInterval < 3 {
            timeInterval = 3
        }
        
        return TimeInterval(timeInterval)
    }
}
