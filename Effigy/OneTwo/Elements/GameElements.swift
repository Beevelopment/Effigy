//
//  GameElements.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/22/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let Player: UInt32 = 0x00
    static let ObstacleAndCoin: UInt32 = 0x01
}

enum ObstacleType: Int {
    case Small = 0
    case Medium = 1
    case Large = 2
}

enum RowType: Int {
    case oneSmall = 0
    case oneMedium = 1
    case oneLarge = 2
    case twoSmall = 3
    case twoMedium = 4
    case threeSmall = 5
    case twoMediumOneSmall = 6
    case twoSmallOneMenium = 7
}

enum RowColors {
    static let colors = [
        UIColor(red: 238 / 255, green: 76 / 255, blue: 124 / 255, alpha: 1),
        UIColor(red: 227 / 255, green: 175 / 255, blue: 188 / 255, alpha: 1),
        UIColor(red: 69 / 255, green: 162 / 255, blue: 158 / 255, alpha: 1),
        UIColor(red: 195 / 255, green: 141 / 255, blue: 158 / 255, alpha: 1),
        UIColor(red: 65 / 255, green: 179 / 255, blue: 163 / 255, alpha: 1),
        UIColor(red: 255 / 255, green: 203 / 255, blue: 154 / 255, alpha: 1),
        UIColor(red: 234 / 255, green: 231 / 255, blue: 220 / 255, alpha: 1),
    ]
}

extension GameScene {
    
    func addPlayer(imageName: String) {
        leftPlayer = SKSpriteNode(imageNamed: imageName)
        setupPlayer(player: leftPlayer)
        rightPlayer = SKSpriteNode(imageNamed: imageName)
        setupPlayer(player: rightPlayer)
        
    }
    
    func setupPlayer(player: SKSpriteNode) {
        player.size = CGSize(width: 30, height: 30)
        player.position = CGPoint(x: self.frame.midX, y: self.frame.height / 3.5)
        player.name = "player"
        player.physicsBody?.isDynamic = false
        player.physicsBody = SKPhysicsBody(circleOfRadius: 12.5)
        player.physicsBody?.categoryBitMask = CollisionBitMask.Player
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = CollisionBitMask.ObstacleAndCoin
        player.zPosition = 2
        
        addChild(player)
        
        initalPlayerPosition = player.position
    }
    
    func addCoin() -> SKSpriteNode {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 20, height: 20)
        coin.position = CGPoint(x: 0, y: self.frame.height + coin.frame.height)
        coin.name = "coin"
        coin.physicsBody?.isDynamic = true
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        coin.physicsBody?.categoryBitMask = CollisionBitMask.ObstacleAndCoin
        coin.physicsBody?.collisionBitMask = 0
        coin.zPosition = 1
        
        return coin
    }
    
    func addObstacle(type: ObstacleType) -> SKShapeNode {
        var obstacle = SKShapeNode()
        
        obstacle.physicsBody?.isDynamic = true
        
        switch type {
        case .Small:
            obstacle = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.18, height: 20), cornerRadius: 10)
            break
        case .Medium:
            obstacle = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.33, height: 20), cornerRadius: 10)
            break
        case .Large:
            obstacle = SKShapeNode(rectOf: CGSize(width: self.frame.width * 0.68, height: 20), cornerRadius: 10)
            break
        }
        
        obstacle.lineWidth = 0
        obstacle.position = CGPoint(x: 0, y: self.frame.height + obstacle.frame.height)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.frame.width, height: obstacle.frame.height))
        obstacle.physicsBody?.categoryBitMask = CollisionBitMask.ObstacleAndCoin
        obstacle.physicsBody?.collisionBitMask = 0
        
        return obstacle
    }
    
    func addMovment(node: SKNode) {
        var actionArray = [SKAction]()
        
        let moveAction = SKAction.moveTo(y: -node.frame.height, duration: TimeInterval(3))
        let removeAction = SKAction.removeFromParent()
        
        actionArray.append(moveAction)
        actionArray.append(removeAction)
        
        node.run(SKAction.sequence(actionArray))
    }
    
    func addRow(type: RowType) {
        let randomNumber = Int(arc4random_uniform(7))
        let isPrimeRandom = Int(arc4random_uniform(150))
        
        switch type {
        case .oneSmall:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width / 4)
                positionConis(xp: self.frame.width / 4 * 3)
            }
            positionObstacle(type: .Small, xp: self.frame.midX, color: randomNumber)
            break
        case .oneMedium:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width * 0.16)
                positionConis(xp: self.frame.width * 0.84)
            }
            positionObstacle(type: .Medium, xp: self.frame.midX, color: randomNumber)
            break
        case .oneLarge:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width * 0.08)
                positionConis(xp: self.frame.width * 0.92)
            }
            positionObstacle(type: .Large, xp: self.frame.midX, color: randomNumber)
            break
        case .twoSmall:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.midX)
            }
            positionObstacle(type: .Small, xp: self.frame.width * 0.3, color: randomNumber)
            positionObstacle(type: .Small, xp: self.frame.width * 0.7, color: randomNumber)
            break
        case .twoMedium:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.midX)
            }
            positionObstacle(type: .Medium, xp: self.frame.width * 0.25, color: randomNumber)
            positionObstacle(type: .Medium, xp: self.frame.width * 0.75, color: randomNumber)
            break
        case .threeSmall:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width * 0.35)
                positionConis(xp: self.frame.width * 0.65)
            }
            positionObstacle(type: .Small, xp: self.frame.width * 0.2, color: randomNumber)
            positionObstacle(type: .Small, xp: self.frame.midX, color: randomNumber)
            positionObstacle(type: .Small, xp: self.frame.width * 0.8, color: randomNumber)
            break
        case .twoMediumOneSmall:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width * 0.3375)
                positionConis(xp: self.frame.width * 0.6625)
            }
            positionObstacle(type: .Medium, xp: self.frame.width * 0.1, color: randomNumber)
            positionObstacle(type: .Medium, xp: self.frame.width * 0.9, color: randomNumber)
            positionObstacle(type: .Small, xp: self.frame.midX, color: randomNumber)
            break
        case .twoSmallOneMenium:
            if isPrime(isPrimeRandom) {
                positionConis(xp: self.frame.width * 0.26)
                positionConis(xp: self.frame.width * 0.74)
            }
            positionObstacle(type: .Small, xp: self.frame.width * 0.1, color: randomNumber)
            positionObstacle(type: .Small, xp: self.frame.width * 0.9, color: randomNumber)
            positionObstacle(type: .Medium, xp: self.frame.midX, color: randomNumber)
            break
        }
    }
    
    func positionConis(xp: CGFloat) {
        let coin = addCoin()
        coin.position = CGPoint(x: xp, y: coin.position.y)
        addMovment(node: coin)
        addChild(coin)
    }
    
    func positionObstacle(type: ObstacleType, xp: CGFloat, color: Int) {
        let obst = addObstacle(type: type)
        obst.fillColor = RowColors.colors[color]
        obst.position = CGPoint(x: xp, y: obst.position.y)
        addMovment(node: obst)
        addChild(obst)
    }
    
    func isPrime(_ number: Int) -> Bool {
        return number > 1 && !(2..<number).contains { number % $0 == 0 }
    }
}
