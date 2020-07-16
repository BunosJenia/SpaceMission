//
//  Background.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/16/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "background")
        super.init(texture: texture, color: .clear, size: texture.size())
        name = "Background"
        zPosition = 0
        anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Background {
    func setupBackground(_ scene: SKScene) {
        for i in 0...1 {
            let background = Background()
            background.size = scene.size
            background.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * CGFloat(i))
            scene.addChild(background)
        }
    }
    
    func moveBackground(_ scene: GameScene) {
        scene.enumerateChildNodes(withName: "Background") { (node, _) in
            let node = node as! SKSpriteNode
            node.position.y -= 5
            
            if node.position.y < -scene.frame.height {
                node.position.y += scene.frame.height * 2
            }
        }
    }
}
