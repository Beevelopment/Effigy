//
//  MenuScene.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/22/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class MenuScene: SKScene {
    
    let fadedBackground = SKSpriteNode()
    
    var settingsNode = SKSpriteNode(imageNamed: "settings")
    var musicNode = SKSpriteNode(imageNamed: "musicplayeron")
    let removeAds = SKSpriteNode(imageNamed: "ads")
    let restorePurchase = SKSpriteNode(imageNamed: "transaction")
    
    let oneCoin = SKSpriteNode(imageNamed: "coin")
    let oneCoinLabel = SKLabelNode(text: "410")
    let twoCoins = SKSpriteNode(imageNamed: "twoCoins")
    let twoCoinsLabel = SKLabelNode(text: "2560")
    let threeCoins = SKSpriteNode(imageNamed: "threeCoins")
    let threeCoinsLabel = SKLabelNode(text: "11830")
    
    var coinNode = SKSpriteNode(imageNamed: "coin")
    static var numberOfCoins = SKLabelNode(text: "\(UserDefaults.standard.integer(forKey: "coins"))")
    
    let gameLogo = SKSpriteNode(imageNamed: "logoNew")
    let begingGame = SKLabelNode(text: "Tap to Play")
    let highscoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "Highscore"))")
    let recentScoreLabel = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: "RecentScore"))")
    
    var unlockedFrames = [SKTexture]()
    var lockedFrames = [SKTexture]()
    
    let leftButton = SKSpriteNode(imageNamed: "left")
    let rightButton = SKSpriteNode(imageNamed: "right")
    
    var playerIconOne = SKSpriteNode()
    var playerIconTwo = SKSpriteNode()
    var playerIconThree = SKSpriteNode()
    
//    let randomAvatar = SKSpriteNode(imageNamed: "shuffle")
    
    var unlockedIcons = UserDefaults.standard.array(forKey: "unlockedIcons") as? [Int] ?? [Int]()
    
    var settingsBool = false
    
    let confettiSprtieNode = SKSpriteNode(imageNamed: "confetti-1")
    var confettiFrames = [SKTexture]()
    
    override func didMove(to view: SKView) {
        setupScene()
        MenuScene.numberOfCoins.fontName = "Quango"
        setupConfettiAnimation()
        
        if !UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            showAd()
        }
    }
    
    func showAd() {
        if GameScene.showAd == 2 {
            if GameViewController.interstitial.isReady {
                let rootViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                GameViewController.interstitial.present(fromRootViewController: rootViewController)
            } else {
                return
            }
        }
    }
    
    func setupPlayerIconNodes() {
        
        let bottomMargin = frame.height * 0.24
        let iconSize = CGSize(width: 30, height: 30)
        
        leftButton.size = iconSize
        playerIconOne.size = iconSize
        playerIconTwo.size = CGSize(width: 62, height: 62)
        playerIconThree.size = iconSize
        rightButton.size = iconSize
        
//        randomAvatar.size = iconSize
        
        leftButton.position = CGPoint(x: 40, y: bottomMargin)
        playerIconOne.position = CGPoint(x: frame.width * 0.28, y: bottomMargin)
        playerIconTwo.position = CGPoint(x: frame.midX, y: bottomMargin)
        playerIconThree.position = CGPoint(x: frame.width * 0.72, y: bottomMargin)
        rightButton.position = CGPoint(x: frame.width - 40, y: bottomMargin)
        
        
        playerIconOne.zPosition = ZPosition.lable
        playerIconTwo.zPosition = ZPosition.lable
        playerIconThree.zPosition = ZPosition.lable
//        randomAvatar.position = CGPoint(x: frame.midX, y: frame.height * 0.20)
        
        addChild(leftButton)
        addChild(playerIconOne)
        addChild(playerIconTwo)
        addChild(playerIconThree)
        addChild(rightButton)
        
//        addChild(randomAvatar)
        
        setCorrectIcon(textureName: UserDefaults.standard.integer(forKey: "playIcon"))
    }
    
//    func setRandomAvatar() {
//        let numberOfAvatars = UInt32(unlockedFrames.count)
//        let randomInt = Int(arc4random_uniform(numberOfAvatars))
//
//        if unlockedIcons.contains(randomInt) {
//            begingGame.text = "Tap to Play"
//            begingGame.fontSize = frame.width * 0.11
//        } else {
//            begingGame.text = "Tap to Unlock Avatar"
//            begingGame.fontSize = frame.width * 0.075
//        }
//
//        setCorrectIcon(textureName: randomInt)
//    }
    
    func setCorrectIcon(textureName: Int) {
        if textureName == 0 {
            
            playerIconOne.texture = .none
            setupTextureOnStart(place: textureName, playerIcon: playerIconTwo, unlockedTexture: unlockedFrames[textureName], lockedTexture: lockedFrames[textureName])
            setupTextureOnStart(place: textureName + 1, playerIcon: playerIconThree, unlockedTexture: unlockedFrames[textureName + 1], lockedTexture: lockedFrames[textureName + 1])
            
        } else if textureName == unlockedFrames.count - 1 {

            setupTextureOnStart(place: textureName - 1, playerIcon: playerIconOne, unlockedTexture: unlockedFrames[textureName - 1], lockedTexture: lockedFrames[textureName - 1])
            setupTextureOnStart(place: textureName, playerIcon: playerIconTwo, unlockedTexture: unlockedFrames[textureName], lockedTexture: lockedFrames[textureName])
            playerIconThree.texture = .none
            
        } else {

            setupTextureOnStart(place: textureName - 1, playerIcon: playerIconOne, unlockedTexture: unlockedFrames[textureName - 1], lockedTexture: lockedFrames[textureName - 1])
            setupTextureOnStart(place: textureName, playerIcon: playerIconTwo, unlockedTexture: unlockedFrames[textureName], lockedTexture: lockedFrames[textureName])
            setupTextureOnStart(place: textureName + 1, playerIcon: playerIconThree, unlockedTexture: unlockedFrames[textureName + 1], lockedTexture: lockedFrames[textureName + 1])
        
        }
    }
    
    func loadLockedIconFrames() {
        let lockedIconTextureAtlas = SKTextureAtlas(named: "LockedIcon")

        for index in 0..<lockedIconTextureAtlas.textureNames.count {
            let textureName = String(index)
            lockedFrames.append(lockedIconTextureAtlas.textureNamed(textureName))
        }
    }
    
    func loadUnlockedIconFrames() {
        let unlockedIconTextureAtlas = SKTextureAtlas(named: "unlocked")
        
        for index in 0..<unlockedIconTextureAtlas.textureNames.count {
            let textureName = "u" + String(index)
            unlockedFrames.append(unlockedIconTextureAtlas.textureNamed(textureName))
        }
    }
    
    func setupScene() {
        backgroundColor = UIColor(red: 44 / 255, green: 62 / 255, blue: 80 / 255, alpha: 1)
        addLabels()
        addButtons()
        loadUnlockedIconFrames()
        loadLockedIconFrames()
        setupPlayerIconNodes()
    }
    
    func addButtons() {
        let topMargin = frame.height - 75
        let nodeSize = CGSize(width: 30, height: 30)
        let coinSize = CGSize(width: 50, height: 50)
        let outOfBounds = CGPoint(x: -500, y: 0)
        
        settingsNode.size = nodeSize
        musicNode.size = nodeSize
        coinNode.size = nodeSize
        removeAds.size = nodeSize
        restorePurchase.size = nodeSize
        
        oneCoin.size = coinSize
        twoCoins.size = coinSize
        threeCoins.size = coinSize
        
        settingsNode.position = CGPoint(x: 30, y: topMargin)
        musicNode.position = CGPoint(x: settingsNode.position.x + 50, y: topMargin)

        coinNode.position = CGPoint(x: frame.width - 30, y: topMargin)
        MenuScene.numberOfCoins.position = CGPoint(x: coinNode.position.x - (MenuScene.numberOfCoins.frame.width * 0.5) - coinNode.frame.width, y: topMargin - 10)
        
        MenuScene.numberOfCoins.fontSize = 28.0
        MenuScene.numberOfCoins.fontColor = .white
        
        oneCoin.position = outOfBounds
        oneCoinLabel.position = outOfBounds
        removeAds.position = outOfBounds
        restorePurchase.position = outOfBounds
        twoCoins.position = outOfBounds
        twoCoinsLabel.position = outOfBounds
        threeCoins.position = outOfBounds
        threeCoinsLabel.position = outOfBounds
        
        addChild(settingsNode)
        addChild(musicNode)
        addChild(coinNode)
        addChild(MenuScene.numberOfCoins)
        addChild(removeAds)
        addChild(restorePurchase)
        
        addChild(oneCoin)
        addChild(oneCoinLabel)
        addChild(twoCoins)
        addChild(twoCoinsLabel)
        addChild(threeCoins)
        addChild(threeCoinsLabel)
    }
    
    func addLabels() {
        
        begingGame.fontName = "Quango"
        begingGame.fontSize = frame.width * 0.11
        begingGame.fontColor = UIColor(red: 234 / 255, green: 231 / 255, blue: 220 / 255, alpha: 1)
        
        highscoreLabel.fontName = "Quango"
        highscoreLabel.fontSize = frame.width * 0.05
        highscoreLabel.fontColor = .white
        
        recentScoreLabel.fontName = "Quango"
        recentScoreLabel.fontSize = frame.width * 0.045
        recentScoreLabel.fontColor = .white
        
        oneCoinLabel.fontName = "Quango"
        oneCoinLabel.fontSize = frame.width * 0.05
        oneCoinLabel.fontColor = .white
        
        twoCoinsLabel.fontName = "Quango"
        twoCoinsLabel.fontSize = frame.width * 0.05
        twoCoinsLabel.fontColor = .white
        
        threeCoinsLabel.fontName = "Quango"
        threeCoinsLabel.fontSize = frame.width * 0.05
        threeCoinsLabel.fontColor = .white
        
        gameLogo.size = CGSize(width: frame.width * 0.66, height: frame.width * 0.66)
        gameLogo.position = CGPoint(x: frame.midX, y: frame.midY * 1.4)
        begingGame.position = CGPoint(x: frame.midX, y: frame.height * 0.47)
        
        highscoreLabel.position = CGPoint(x: frame.midX, y: begingGame.position.y - highscoreLabel.frame.height * 3)
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highscoreLabel.position.y - recentScoreLabel.frame.height * 2)
        
        addChild(gameLogo)
        addChild(begingGame)
        addChild(highscoreLabel)
        addChild(recentScoreLabel)
        
        animateBegingButton(label: begingGame)
    }
    
    func animateBegingButton(label: SKLabelNode) {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.8)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.8)
        
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            if musicNode.contains(location) {
                if !settingsBool {
                    musicButton()
                } else {
                    removeAdsFunc()
                }
            } else if leftButton.contains(location) {
                handelLeftButton()
            } else if rightButton.contains(location) {
                handelRightButton()
            } else if settingsNode.contains(location) {
                settingsButton()
            } else if oneCoin.contains(location) {
                fourHundred()
            } else if twoCoins.contains(location) {
                twoThousand()
            } else if threeCoins.contains(location) {
                elevenThousand()
            } else if restorePurchase.contains(location) {
                restoreIAP()
            } else {
                startGame()
            }
        }
    }
    
    func startGame() {
        if let imageName = playerIconTwo.texture?.name {
            if imageName.contains("u") {
                var imgName = imageName
                imgName.removeFirst()
                playGame(postionInTexture: imgName)
            } else if imageName == "0" {
                playGame(postionInTexture: imageName)
            } else {
                purchaseAvatar()
            }
        }
    }
    
    func playGame(postionInTexture: String) {
        if let iconName = Int(postionInTexture) {
            playIconChoosen(iconName: iconName)
            let gameScene = GameScene(size: view!.bounds.size)
            view!.presentScene(gameScene)
        }
    }
    
    func settingsButton() {
        let topMargin = frame.height - 75
        let titelPosition = frame.height * 0.7
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let moveDown = SKAction.moveTo(y: begingGame.position.y, duration: 0.2)
        let moveUp = SKAction.moveTo(y: titelPosition, duration: 0.2)
    
        if !settingsBool {
            removeAds.position = musicNode.position
            restorePurchase.position = CGPoint(x: removeAds.position.x + 50, y: topMargin)
            
            twoCoins.position = CGPoint(x: frame.midX, y: titelPosition)
            twoCoinsLabel.position = CGPoint(x: twoCoins.position.x, y: twoCoins.position.y - twoCoins.frame.height)
            oneCoin.position = CGPoint(x: twoCoins.position.x - 90, y: titelPosition)
            oneCoinLabel.position = CGPoint(x: oneCoin.position.x, y: twoCoins.position.y - twoCoins.frame.height)
            threeCoins.position = CGPoint(x: twoCoins.position.x + 90, y: titelPosition)
            threeCoinsLabel.position = CGPoint(x: threeCoins.position.x, y: twoCoins.position.y - twoCoins.frame.height)
            
            gameLogo.run(moveDown)
            begingGame.run(fadeOut)
            highscoreLabel.run(fadeOut)
            recentScoreLabel.run(fadeOut)
            musicNode.run(fadeOut)
            oneCoin.run(fadeIn)
            oneCoinLabel.run(fadeIn)
            twoCoins.run(fadeIn)
            twoCoinsLabel.run(fadeIn)
            threeCoins.run(fadeIn)
            threeCoinsLabel.run(fadeIn)
            removeAds.run(fadeIn)
            restorePurchase.run(fadeIn)
            
            settingsBool = true
        } else  {
            restorePurchase.run(fadeOut)
            removeAds.run(fadeOut)
            threeCoins.run(fadeOut)
            threeCoinsLabel.run(fadeOut)
            twoCoins.run(fadeOut)
            twoCoinsLabel.run(fadeOut)
            oneCoin.run(fadeOut)
            oneCoinLabel.run(fadeOut)
            musicNode.run(fadeIn)
            highscoreLabel.run(fadeIn)
            recentScoreLabel.run(fadeIn)
            begingGame.run(fadeIn)
            gameLogo.run(moveUp)
            settingsBool = false
        }
    }
    
    func musicButton() {
        if GameViewController.avAudioPlayer.isPlaying {
            GameViewController.avAudioPlayer.pause()
            UserDefaults.standard.set(false, forKey: "musicBool")
        } else {
            GameViewController.avAudioPlayer.play()
            GameViewController.avAudioPlayer.numberOfLoops = -1
            UserDefaults.standard.set(true, forKey: "musicBool")
        }
    }
    
    func purchaseAvatar() {
        if let coinsText = MenuScene.numberOfCoins.text {
            guard let coins = Int(coinsText) else { return }
            if coins > 164 {
                if let currentAvatar = playerIconTwo.texture?.name {
                    if let current = Int(currentAvatar) {
                        unlockedIcons.append(current)
                        UserDefaults.standard.set(unlockedIcons, forKey: "unlockedIcons")
                        let actualCoins = coins - 165
                        UserDefaults.standard.set(actualCoins, forKey: "coins")
                        MenuScene.numberOfCoins.text = "\(actualCoins)"
                        
                        setCorrectIcon(textureName: current)
                        
                        newAvatarAnimation()
                    }
                }
            } else {
                alert()
                print("Carl: not enough coins")
            }
        }
    }
    
    func newAvatarAnimation() {
        
        if !settingsBool {
            let rotateAvatarFirst = SKAction.rotate(toAngle: CGFloat(Double.pi * 2), duration: 1)
            let rotateAvatarSecond = SKAction.rotate(toAngle: -CGFloat(Double.pi * 2), duration: 1)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            
            let scaleAvatarUp = SKAction.scale(to: CGSize(width: 125, height: 125), duration: 1)
            let moveAvatarUp = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 1)
            
            let scaleAvatarDown = SKAction.scale(to: CGSize(width: 62, height: 62), duration: 1)
            let moveAvatarDown = SKAction.move(to: CGPoint(x: frame.midX, y: frame.height * 0.28), duration: 1)
            
            gameLogo.run(fadeOut)
            begingGame.run(fadeOut)
            highscoreLabel.run(fadeOut)
            recentScoreLabel.run(fadeOut)
            playerIconTwo.run(rotateAvatarFirst)
            playerIconTwo.run(scaleAvatarUp)
            playerIconTwo.run(moveAvatarUp)
            playConfettiAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                self.playerIconTwo.run(rotateAvatarSecond)
                self.playerIconTwo.run(scaleAvatarDown)
                self.playerIconTwo.run(moveAvatarDown)
                self.gameLogo.run(fadeIn)
                self.begingGame.run(fadeIn)
                self.highscoreLabel.run(fadeIn)
                self.recentScoreLabel.run(fadeIn)
            }
            
            begingGame.text = "Tap to Play"
            begingGame.fontSize = frame.width * 0.11
        } else {
            settingsButton()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.newAvatarAnimation()
            }
        }
        
    }
    
    func playConfettiAnimation() {
        confettiSprtieNode.zPosition = ZPosition.lable
        
        let action = SKAction.animate(with: confettiFrames, timePerFrame: 0.05)
        let repeatAction = SKAction.repeat(action, count: 3)
        let moveDown = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.height - 200), duration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        confettiSprtieNode.run(SKAction.sequence([repeatAction, fadeOut]))
        confettiSprtieNode.run(moveDown)
        
        if UserDefaults.standard.bool(forKey: "musicBool") {
            playSound(soundFileName: "highscoresound")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            self.confettiSprtieNode.position = CGPoint(x: self.frame.midX, y: self.frame.height + 200)
            self.confettiSprtieNode.run(SKAction.fadeIn(withDuration: 0))
        }
    }
    
    func playSound(soundFileName: String) {
        let playSound = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
        self.run(SKAction.sequence([playSound, playSound]))
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
    
    func setupTextureOnStart(place: Int, playerIcon: SKSpriteNode, unlockedTexture: SKTexture, lockedTexture: SKTexture) {
        if unlockedIcons.contains(place) {
            playerIcon.texture = unlockedTexture
        } else {
            playerIcon.texture = lockedTexture
        }
    }
    
    func playIconChoosen(iconName: Int) {
            UserDefaults.standard.set(iconName, forKey: "playIcon")
    }
    
    func alert() {
        let noCoins = UIAlertController(title: "Not Enough Coins", message: "Unfortunately you don't have enough coins to purchase a new avatar. Would you like to purchase more coins?", preferredStyle: .alert)
        let noBtn = UIAlertAction(title: "Maybe Later", style: .default) { (action) in
        }
        let yesBtn = UIAlertAction(title: "Yes!", style: .default) { (action) in
            self.settingsButton()
        }
        
        noCoins.addAction(noBtn)
        noCoins.addAction(yesBtn)
        
        view?.window?.rootViewController?.present(noCoins, animated: true, completion: nil)
    }
}

extension SKTexture {
    var name:String? {
        let comps = description.components(separatedBy: "'")
        return comps.count > 1 ? comps[1] : nil
    }
}
//Code for randomized purchase

//                let allAvatarsCount = unlockedFrames.count
//                var possibleAvatarsToPurchase = [Int]()
//
//                for avatar in 0..<allAvatarsCount {
//                    if !unlockedIcons.contains(avatar) {
//                        possibleAvatarsToPurchase.append(avatar)
//                    }
//                }
//
//                let randomNumber = Int(arc4random_uniform(UInt32(possibleAvatarsToPurchase.count)))
//                let randomAvatar = possibleAvatarsToPurchase[randomNumber]
//
//                unlockedIcons.append(randomAvatar)
//                UserDefaults.standard.set(unlockedIcons, forKey: "unlockedIcons")
//
//                setCorrectIcon(textureName: randomAvatar)

