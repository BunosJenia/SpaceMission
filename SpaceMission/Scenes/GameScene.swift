//
//  GameScene.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/9/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene {
    var levelNumber = 0
    var livesNumber = 3
    
    var playerNode = Player()
    var hud = HeadUpDisplay()
    var backgroundNode = Background()
    
    var currentGameState = GameState.preGame
    var enemiesCount = 0
    var asteroidsCount = 0

    let gameArea: CGRect
    
    let bulletSound = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    
    let enemyCountPerLevel = 5
    let asteroidsCountPerLevel = 1
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat
        
        switch UIScreen.main.nativeBounds.height {
        case 2688, 1792, 2436:
            maxAspectRatio = 2.16
        default:
            maxAspectRatio = 16 / 9
        }
        
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentGameState == GameState.preGame {
            self.startGame()
        } else if currentGameState == GameState.inGame {
             self.fireBullet()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if currentGameState == GameState.inGame {
                playerNode.playerMovement(touch: touch, scene: self, gameArea: gameArea)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if currentGameState == GameState.inGame {
            backgroundNode.moveBackground(self)
            
            if enemiesCount == 0 {
                self.startNewLevel()
            }
        }
    }
}

extension GameScene {
    func setupNodes() {
        backgroundNode.setupBackground(self)
        playerNode.setupPlayer(scene: self)
        
        self.addChild(hud)
        
        hud.setupScoreLabel(gameScore)
        hud.setupLiveLabel(livesNumber)
        hud.setupGameOverLabel()
        hud.setupTapToStartLabel()
    }
    
    func fireBullet() {
        let bullet = Bullet()
        
        bullet.addBullet(scene: self, playerNode: playerNode, bulletSound: bulletSound)
    }
    
    func spawnEnemy() {
        let enemy = Enemy()
        
        if currentGameState == GameState.inGame {
            enemy.setupEnemy(self)
        }
    }
    
    func spawnAsteroid() {
        let asteroid = Asteroid()
        
        if currentGameState == GameState.inGame {
            asteroid.setupAsteroid(self)
        }
    }
    
    func startNewLevel() {
        levelNumber += 1
        
        self.updateEnemiesCount()
        
        self.run(.sequence([
            .run {
                self.hud.setupLevelLabel(self.levelNumber)
            },
            .wait(forDuration: 1),
            .run {
                self.playerNode.runToStartPoint(self)
            }
        ]))
        

        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        if self.action(forKey: "spawningAsteroids") != nil {
            self.removeAction(forKey: "spawningAsteroids")
        }
        
        let repeatEnemySequenceAction = SKAction.repeat(.sequence([.run(spawnEnemy), .wait(forDuration: self.getLevelDurationTime())]), count: enemiesCount)
        
        let repeatAsteroidSequenceAction = SKAction.repeat(.sequence([.run(spawnAsteroid), .wait(forDuration: self.getLevelDurationTimeForAsteroids())]), count: asteroidsCount)
        
        self.run(.sequence([.wait(forDuration: 2.5), repeatEnemySequenceAction]), withKey: "spawningEnemies")
        
        self.run(.sequence([.wait(forDuration: 3.5), repeatAsteroidSequenceAction]), withKey: "spawningAsteroids")
    }
    
    func updateEnemiesCount() {
        enemiesCount = self.levelNumber * self.enemyCountPerLevel
        asteroidsCount = self.levelNumber * self.asteroidsCountPerLevel
    }
    
    func getLevelDurationTime() -> Double{
        var levelDuration = 1.2 - Double(self.levelNumber) * 0.1
        
        if levelDuration < 0.5 {
            levelDuration = 0.5
        }
        
        return levelDuration
    }
    
    func getLevelDurationTimeForAsteroids() -> Double{
        var levelDuration = 5 - Double(self.levelNumber) / 2
        
        if levelDuration < 1 {
            levelDuration = 1
        }
        
        return levelDuration
    }
    
    func addScore() {
        gameScore += 1
        
        hud.updateScore(gameScore)
    }
    
    func loseALife() {
        livesNumber -= 1
        hud.updateLive(livesNumber)
        
        self.run(explosionSound)
        
        if livesNumber == 0 {
            gameOver()
        }
    }
    
    func gameOver() {
        self.removeAllActions()
        
        let highscore = ScoreGenerator.sharedInstance.getHighscore()
        
        if gameScore > highscore {
            ScoreGenerator.sharedInstance.setHighscore(gameScore)
        }
        
        currentGameState = GameState.afterGame
        
        self.enumerateChildNodes(withName: "Bullet") { (bullet, _) in
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy") { (enemy, _) in
            enemy.removeAllActions()
        }
        
        self.run(.sequence([.wait(forDuration: 1), .run(changeScene)]))
    }
    
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 0.5)
        
        sceneToMoveTo.scaleMode = self.scaleMode
        
        self.view?.presentScene(sceneToMoveTo, transition: transition)
    }
    
    func startGame() {
        currentGameState = GameState.inGame
        
        hud.tapToStartLabel.run(.sequence([.fadeOut(withDuration: 0.5), .removeFromParent()]))
    }
    
    func updateUIForNewLevel() {
        self.playerNode.runToEndPoint(self)
        
        self.enumerateChildNodes(withName: "Asteroid") { (asteroid, _) in
            asteroid.run(.sequence([.fadeOut(withDuration: 0.1), .removeFromParent()]))
        }
    }
    
    func reduceEnemyCount() {
        self.enemiesCount -= 1
    }
}


// Mark: Physics
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            secondBody = contact.bodyA
            firstBody = contact.bodyB
        }
        
        // Player hits Enemy or Asteroid
        if firstBody.categoryBitMask == PhysicsCategory.Player && (secondBody.categoryBitMask == PhysicsCategory.Enemy || secondBody.categoryBitMask == PhysicsCategory.Asteroid) {
            if  firstBody.node != nil {
                Explosion.spawnExplosion(explosionSound: explosionSound, spawnPosition: firstBody.node!.position, scene: self)
            }
            
            if  secondBody.node != nil {
                Explosion.spawnExplosion(explosionSound: explosionSound, spawnPosition: secondBody.node!.position, scene: self)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
            gameOver()
        }
        
        // Bullet hits Enemy
        if firstBody.categoryBitMask == PhysicsCategory.Bullet && secondBody.categoryBitMask == PhysicsCategory.Enemy && secondBody.node!.position.y <  self.size.height {
            addScore()
            self.reduceEnemyCount()
            
            if enemiesCount == 0 {
                self.run(.run(self.updateUIForNewLevel))
            }
            
            if  secondBody.node != nil {
                Explosion.spawnExplosion(explosionSound: explosionSound, spawnPosition: secondBody.node!.position, scene: self)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }
        
        // Bullet hits Asteroid
        if firstBody.categoryBitMask == PhysicsCategory.Bullet && secondBody.categoryBitMask == PhysicsCategory.Asteroid && secondBody.node!.position.y <  self.size.height {
            addScore()
            
            if  secondBody.node != nil {
                Explosion.spawnExplosion(explosionSound: explosionSound, spawnPosition: secondBody.node!.position, scene: self)
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }
        
    }
}
