//
//  MainMenuScene.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/16/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    var hud = HeadUpDisplay()
    var background = Background()
    
    override func didMove(to view: SKView) {
        background.setupBackground(self)
        
        self.addChild(background)
        
        self.addChild(hud)
        
        hud.setupMainMenuLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if hud.startGameLabel.contains(location) {
                let sceneToMoveTo = GameScene(size: self.size)
                let transition = SKTransition.fade(withDuration: 0.5)
                
                sceneToMoveTo.scaleMode = self.scaleMode
                
                self.view?.presentScene(sceneToMoveTo, transition: transition)
            }
        }
    }
}
