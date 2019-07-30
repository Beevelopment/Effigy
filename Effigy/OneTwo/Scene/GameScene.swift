//
//  GameScene.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/22/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import SpriteKit
import AVFoundation

enum ZPosition {
    static let lable: CGFloat = 3
    static let container: CGFloat = 2
    static let rows: CGFloat = 1
    static let ball: CGFloat = 0
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static var showAd: Int = 0
    
    var leftPlayer: SKSpriteNode!
    var rightPlayer: SKSpriteNode!
    
    var initalPlayerPosition: CGPoint!
    
    var lastUpdateTimeInterval = TimeInterval()
    var lastYieldTimeIntervel = TimeInterval()
    
    var gameOver: Bool = false
    
    var scoreView = SKShapeNode()
    var highScoreView = SKShapeNode()
    var coinView = SKShapeNode()
    
    let scoreLabel = SKLabelNode(text: "0")
    let highscoreLabel = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: "Highscore"))")
    let coinsLabel = SKLabelNode(text: "0")
    
//    let pauseButton = SKSpriteNode(imageNamed: "pause")
    
    var score = 0
    var highscore = 0
    var points = 0
    var coins = 0
    
    let confettiSprtieNode = SKSpriteNode(imageNamed: "confetti-1")
    var confettiFrames = [SKTexture]()
    
    var newHighScore = false
    
    var avPlayerHighscore: AVAudioPlayer!
    var avPlayerCoin: AVAudioPlayer!
    
    var firstPlay = true
    
    let whiteView = SKSpriteNode()
    let textNode = SKLabelNode(text: "Use 3D Touch to Split the Avatar")
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        layoutScene()
        addPlayer(imageName: "u" + String(UserDefaults.standard.integer(forKey: "playIcon")))
        setupConfettiAnimation()
        highscore = UserDefaults.standard.integer(forKey: "Highscore")
    }
    
    func setupConfettiAnimation() {
        confettiSprtieNode.position = CGPoint(x: self.frame.midX, y: self.frame.height + 200)
        confettiSprtieNode.size = CGSize(width: 500, height: 400)
        addChild(confettiSprtieNode)
        
        let textureAtlas = SKTextureAtlas(named: "Confetti")
        
        for index in 1..<textureAtlas.textureNames.count + 1 {
            let textureName = "confetti-" + String(index)
            confettiFrames.append(textureAtlas.textureNamed(textureName))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let maximumPossibleForce = touch.maximumPossibleForce
            let force = touch.force
            let normalizedForce = force / maximumPossibleForce
            
            leftPlayer.position.x = (self.frame.width / 2) - normalizedForce * (self.frame.width / 2 - 12)
            rightPlayer.position.x = (self.frame.width / 2) + normalizedForce * (self.frame.width / 2 - 12)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        resetPlayerPostion()
    }
    
    func resetPlayerPostion() {
        leftPlayer.position = initalPlayerPosition
        rightPlayer.position = initalPlayerPosition
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 1)
        
        scoreView = SKShapeNode(rectOf: CGSize(width: self.frame.width / 1.5, height: 60), cornerRadius: 30)
        scoreView.position = CGPoint(x: 0, y: self.frame.height - 100)
        scoreView.fillColor = UIColor(red: 65 / 255, green: 189 / 255, blue: 172 / 255, alpha: 1)
        scoreView.lineWidth = 0
        scoreView.zPosition = ZPosition.container
        
        highScoreView = SKShapeNode(rectOf: CGSize(width: self.frame.width / 2, height: 50), cornerRadius: 25)
        highScoreView.position = CGPoint(x: 0, y: self.frame.height - 155)
        highScoreView.fillColor = UIColor(red: 65 / 255, green: 170 / 255, blue: 172 / 255, alpha: 1)
        highScoreView.lineWidth = 0
        highScoreView.zPosition = ZPosition.container
        
        coinView = SKShapeNode(rectOf: CGSize(width: self.frame.width / 2, height: 50), cornerRadius: 25)
        coinView.position = CGPoint(x: self.frame.width, y: self.frame.height - 95)
        coinView.fillColor = UIColor(red: 65 / 255, green: 170 / 255, blue: 172 / 255, alpha: 1)
        coinView.lineWidth = 0
        coinView.zPosition = ZPosition.container
        
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: scoreView.frame.width * 0.2, y: scoreView.frame.midY - scoreView.frame.height / 4)
        scoreLabel.fontSize = 40.0
        scoreLabel.zPosition = ZPosition.lable
        scoreLabel.fontName = "Quango"
        
        highscoreLabel.fontColor = .white
        highscoreLabel.position = CGPoint(x: highScoreView.frame.width * 0.2, y: highScoreView.frame.midY - highScoreView.frame.height / 4)
        highscoreLabel.fontSize = 30
        highscoreLabel.zPosition = ZPosition.lable
        highscoreLabel.fontName = "Quango"
        
        coinsLabel.fontColor = .white
        coinsLabel.position = CGPoint(x: self.frame.width - coinView.frame.width * 0.2, y: coinView.frame.midY - coinView.frame.height / 4)
        coinsLabel.fontSize = 30
        coinsLabel.zPosition = ZPosition.lable
        coinsLabel.fontName = "Quango"
        
//        pauseButton.position = CGPoint(x: frame.width * 0.9, y: coinView.position.y - coinView.frame.height)
//        pauseButton.size = CGSize(width: 30, height: 30)
        
        addChild(highScoreView)
        addChild(scoreView)
        addChild(coinView)
        addChild(scoreLabel)
        addChild(highscoreLabel)
        addChild(coinsLabel)
//        addChild(pauseButton)
    }

    func addRandomRow() {
        let ramdomNumber = Int(arc4random_uniform(8))
        
        switch ramdomNumber {
        case 0:
            addRow(type: RowType(rawValue: 0)!)
            break
        case 1:
            addRow(type: RowType(rawValue: 1)!)
            break
        case 2:
            addRow(type: RowType(rawValue: 2)!)
            break
        case 3:
            addRow(type: RowType(rawValue: 3)!)
            break
        case 4:
            addRow(type: RowType(rawValue: 4)!)
            break
        case 5:
            addRow(type: RowType(rawValue: 5)!)
            break
        case 6:
            addRow(type: RowType(rawValue: 6)!)
            break
        case 7:
            addRow(type: RowType(rawValue: 7)!)
            break
        default:
            break
        }
    }
    
    func updateWithTimesinceUpdate(timeSinceLastUpdate: CFTimeInterval) {
        lastYieldTimeIntervel += timeSinceLastUpdate
        if lastYieldTimeIntervel > 0.6 {
            lastYieldTimeIntervel = 0
            addRandomRow()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let totalCoins = UserDefaults.standard.integer(forKey: "coins") + coins
        
        if gameOver {
            if GameScene.showAd < 2 {
                GameScene.showAd += 1
            } else {
                GameScene.showAd = 0
            }
            
            vibrate(vibrationType: 1520)
            UserDefaults.standard.set(score, forKey: "RecentScore")
            if score > UserDefaults.standard.integer(forKey: "Highscore") {
                UserDefaults.standard.set(score, forKey: "Highscore")
            }
            
            UserDefaults.standard.set(totalCoins, forKey: "coins")
            MenuScene.numberOfCoins.text = "\(totalCoins)"
            
            let menuScene = MenuScene(size: view!.bounds.size)
            let transition = SKTransition.fade(withDuration: 1)
            view!.presentScene(menuScene, transition: transition)
        } else {
            points += 1
            score = points / 30
            scoreLabel.text = "\(score)"
            
            coinsLabel.text = "\(coins)"
            
            var timeSinceLastUpdate = currentTime - lastUpdateTimeInterval
            lastUpdateTimeInterval = currentTime
            
            if timeSinceLastUpdate > 1 {
                timeSinceLastUpdate = 1 / 60
                lastUpdateTimeInterval = currentTime
            }
            
            updateWithTimesinceUpdate(timeSinceLastUpdate: timeSinceLastUpdate)
        }
        
        if highscore < score && !newHighScore && highscore != 0 {
            let action = SKAction.animate(with: confettiFrames, timePerFrame: 0.05)
            let repeatAction = SKAction.repeat(action, count: 3)
            let moveDown = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.height - 200), duration: 1)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            confettiSprtieNode.run(SKAction.sequence([repeatAction, fadeOut]))
            confettiSprtieNode.run(moveDown)
            
            if UserDefaults.standard.bool(forKey: "musicBool") {
                playSound(soundFileName: "highscoresound")
            }
            
            newHighScore = true
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == nil && contact.bodyB.node?.name == "player"  {
            gameOver = true
        } else if contact.bodyA.node?.name == "player" && contact.bodyB.node?.name == "coin" {
            coins += 1
            
            let coin = contact.bodyB.node
            coin?.removeFromParent()
            
            if UserDefaults.standard.bool(forKey: "musicBool") {
                playSound(soundFileName: "coin7")
            }
        }
    }
    
    func playSound(soundFileName: String) {
        let playSound = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
        self.run(playSound)
    }
    
    func vibrate(vibrationType: Int) {
        let vibrate = SystemSoundID(vibrationType)
        AudioServicesPlaySystemSound(vibrate)
    }
}
