//
//  HeadUpDisplay.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/15/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit

class HeadUpDisplay: SKNode {
    var fontNamed = "Spaceman"
    
    var scoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    var liveLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var restartLabel: SKLabelNode!
    var tapToStartLabel: SKLabelNode!
    var gameNameLabel: SKLabelNode!
    var startGameLabel: SKLabelNode!
    var levelLabel: SKLabelNode!
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(fontSize: CGFloat, name: String, text: String) {
        guard let scene = scene as? GameScene else { return }
        
        let position = CGPoint(x: scene.gameArea.width / 2, y: scene.gameArea.height / 2 + 300)
        
        addLabel(name, text: text, fontSize: fontSize, position: position)
    }
    
    func addLabel(_ name: String, text: String, fontSize: CGFloat, position: CGPoint) {
        let label = SKLabelNode()
        
        label.fontName = fontNamed
        label.name = name
        label.text = text
        label.position = position
        label.fontSize = fontSize
        label.zPosition = 5
        
        addChild(label)
    }
    
    func setupTapToStartLabel() {
        guard let scene = scene as? GameScene else { return }
        
        addLabel(HUDSettings.tapToStart, text: "Tap to Begin", fontSize: 70, position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2))
        
        tapToStartLabel = childNode(withName: HUDSettings.tapToStart) as? SKLabelNode
        
        tapToStartLabel.alpha = 0
        tapToStartLabel.run(.fadeIn(withDuration: 0.8))
    }
    
    func setupScoreLabel(_ score: Int) {
        guard let scene = scene as? GameScene else { return }
        
        let position = CGPoint(x: scene.gameArea.minX + 50, y: scene.size.height * 1.2)
        
        addLabel(HUDSettings.score, text: "Score: \(score)", fontSize: 40, position: position)
        
        scoreLabel = childNode(withName: HUDSettings.score) as? SKLabelNode

        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        
        moveLiveAndScoreLabels(scoreLabel)
    }
    
    func setupLiveLabel(_ score: Int) {
        guard let scene = scene as? GameScene else { return }
        
        let position = CGPoint(x: scene.gameArea.maxX - 50, y: scene.size.height * 1.2 )
        
        addLabel(HUDSettings.live, text: "Lives: \(score)", fontSize: 40, position: position)
        
        liveLabel = childNode(withName: HUDSettings.live) as? SKLabelNode
        liveLabel.horizontalAlignmentMode = .right
        liveLabel.verticalAlignmentMode = .top
        
        moveLiveAndScoreLabels(liveLabel)
    }
    
    func updateScore(_ score: Int) {
        scoreLabel = childNode(withName: HUDSettings.score) as? SKLabelNode
        
        scoreLabel.text = "Score: \(score)"
    }
    
    func updateLive(_ life: Int) {
        liveLabel = childNode(withName: HUDSettings.live) as? SKLabelNode
        
        liveLabel.text = "Lives: \(life)"
        
        liveLabel.run(.sequence([.scale(to: 1.5, duration: 0.25), .scale(to: 1, duration: 0.25)]))
    }
    
    func setupLevelLabel(_ level: Int) {
        guard let scene = scene as? GameScene else { return }
        addLabel(HUDSettings.level, text: "Level: \(level)", fontSize: 60, position: CGPoint(x: scene.size.width / 2, y: scene.size.height / 2))
        
        levelLabel = childNode(withName: HUDSettings.level) as? SKLabelNode
        
        levelLabel.alpha = 0
        
        levelLabel.run(.sequence([.fadeIn(withDuration: 0.5), .wait(forDuration: 1), .fadeOut(withDuration: 0.5), .removeFromParent()]))
    }
    
    func setupGameOverLabel() {
        guard let scene = scene as? GameOverScene else { return }
        
        let gameoverLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.7)
        let scoreLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.55)
        let highscoreLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.4)
        let restartLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.2)
        
        
        addLabel(HUDSettings.gameOver, text: HUDSettings.gameOver, fontSize: 90, position: gameoverLabelPosition)
        addLabel(HUDSettings.score, text: "Score: \(gameScore)", fontSize: 80, position: scoreLabelPosition)
        addLabel(HUDSettings.highscore, text: "Highcore: \(ScoreGenerator.sharedInstance.getHighscore())", fontSize: 80, position: highscoreLabelPosition)
        addLabel(HUDSettings.restart, text: HUDSettings.restart, fontSize: 60, position: restartLabelPosition)

        
        gameOverLabel = childNode(withName: HUDSettings.gameOver) as? SKLabelNode
        scoreLabel = childNode(withName: HUDSettings.score) as? SKLabelNode
        highscoreLabel = childNode(withName: HUDSettings.highscore) as? SKLabelNode
        restartLabel = childNode(withName: HUDSettings.restart) as? SKLabelNode
    }
    
    func setupMainMenuLabel() {
        guard let scene = scene as? MainMenuScene else { return }
               
        let gameNameLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.8)
        let startGameLabelPosition = CGPoint(x: scene.size.width / 2, y: scene.size.height * 0.5)


        addLabel(HUDSettings.gameName, text: HUDSettings.gameName, fontSize: 70, position: gameNameLabelPosition)
        addLabel(HUDSettings.startGame, text: HUDSettings.startGame, fontSize: 70, position: startGameLabelPosition)


        gameNameLabel = childNode(withName: HUDSettings.gameName) as? SKLabelNode
        startGameLabel = childNode(withName: HUDSettings.startGame) as? SKLabelNode
    }
    
    func moveLiveAndScoreLabels(_ label: SKLabelNode) {
        label.run(.moveTo(y: label.position.y * 0.78, duration: 0.5))
    }
}
