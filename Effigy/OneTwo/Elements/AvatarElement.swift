//
//  AvatarElement.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/27/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import SpriteKit

extension MenuScene {
    
    func handelCharacterMovment(positionOfTexture: String, valueTotestAgainst: Int, left: Bool) {
        if let iconName = Int(positionOfTexture), iconName != valueTotestAgainst {
            if left {
                moveIconsLeft(iconName: iconName)
            } else {
                moveIconsRight(iconName: iconName)
            }
        } else {
            print("Carl: det är första eller sista iconen")
        }
    }
    
    func handelRightButton() {
        if let imageName = playerIconTwo.texture?.name {
            if imageName.contains("u") {
                var imgName = imageName
                imgName.removeFirst()
                handelCharacterMovment(positionOfTexture: imgName, valueTotestAgainst: unlockedFrames.count - 1, left: false)
            } else {
                handelCharacterMovment(positionOfTexture: imageName, valueTotestAgainst: unlockedFrames.count - 1, left: false)
            }
        }
    }
    
    func moveIconsRight(iconName: Int) {
        let moveOneStep = iconName + 1
        let moveTwoSteps = iconName + 2
        
        let changeIconOne: SKAction!
        let changeIconTwo: SKAction!
        let changeIconThree: SKAction!
        
        if unlockedIcons.contains(iconName) {
            changeIconOne = SKAction.animate(with: [unlockedFrames[iconName]], timePerFrame: 0.2)
        } else {
            changeIconOne = SKAction.animate(with: [lockedFrames[iconName]], timePerFrame: 0.2)
        }
        
        if unlockedIcons.contains(moveOneStep) {
            changeIconTwo = SKAction.animate(with: [unlockedFrames[moveOneStep]], timePerFrame: 0.2)
            begingGame.text = "Tap to Play"
            begingGame.fontSize = frame.width * 0.11
        } else {
            changeIconTwo = SKAction.animate(with: [lockedFrames[moveOneStep]], timePerFrame: 0.2)
            begingGame.text = "Tap to Unlock Avatar"
            begingGame.fontSize = frame.width * 0.075
        }
        
        if iconName == unlockedFrames.count - 2 {
            playerIconThree.texture = .none
        } else {
            if unlockedIcons.contains(moveTwoSteps) {
                changeIconThree = SKAction.animate(with: [unlockedFrames[moveTwoSteps]], timePerFrame: 0.2)
            } else {
                changeIconThree = SKAction.animate(with: [lockedFrames[moveTwoSteps]], timePerFrame: 0.2)
            }
            playerIconThree.run(changeIconThree)
        }
        
        playerIconOne.run(changeIconOne)
        playerIconTwo.run(changeIconTwo)
    }
    
    func handelLeftButton() {
        if let imageName = playerIconTwo.texture?.name {
            if imageName.contains("u") {
                var imgName = imageName
                imgName.removeFirst()
                handelCharacterMovment(positionOfTexture: imgName, valueTotestAgainst: 0, left: true)
            } else {
                handelCharacterMovment(positionOfTexture: imageName, valueTotestAgainst: 0, left: true)
            }
        }
    }
    
    func moveIconsLeft(iconName: Int) {
        let moveOneStep = iconName - 1
        let moveTwoSteps = iconName - 2
        
        let changeIconOne: SKAction!
        let changeIconTwo: SKAction!
        let changeIconThree: SKAction!
        
        if unlockedIcons.contains(iconName) {
            changeIconThree = SKAction.animate(with: [unlockedFrames[iconName]], timePerFrame: 0.2)
        } else {
            changeIconThree = SKAction.animate(with: [lockedFrames[iconName]], timePerFrame: 0.2)
        }
        
        if unlockedIcons.contains(moveOneStep) {
            changeIconTwo = SKAction.animate(with: [unlockedFrames[moveOneStep]], timePerFrame: 0.2)
            begingGame.text = "Tap to Play"
            begingGame.fontSize = frame.width * 0.11
        } else {
            changeIconTwo = SKAction.animate(with: [lockedFrames[moveOneStep]], timePerFrame: 0.2)
            begingGame.text = "Tap to Unlock Avatar"
            begingGame.fontSize = frame.width * 0.075
        }
        
        if iconName == 1 {
            playerIconOne.texture = .none
            begingGame.text = "Tap to Play"
            begingGame.fontSize = frame.width * 0.11
        } else {
            if unlockedIcons.contains(moveTwoSteps) {
                changeIconOne = SKAction.animate(with: [unlockedFrames[moveTwoSteps]], timePerFrame: 0.2)
            } else {
                changeIconOne = SKAction.animate(with: [lockedFrames[moveTwoSteps]], timePerFrame: 0.2)
            }
            playerIconOne.run(changeIconOne)
        }
        
        playerIconTwo.run(changeIconTwo)
        playerIconThree.run(changeIconThree)
    }
    
    func removeAdsFunc() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let sequens = SKAction.sequence([fadeOut, fadeIn])
        
        removeAds.run(sequens)
        PurchaseManager.instance.purchaseRemoveAds { success in }
    }
    
    func fourHundred() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let sequens = SKAction.sequence([fadeOut, fadeIn])
        
        oneCoin.run(sequens)
        
        PurchaseManager.instance.purchaseFourHundredTen { success in }
    }
    
    func twoThousand() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let sequens = SKAction.sequence([fadeOut, fadeIn])
        
        twoCoins.run(sequens)

        PurchaseManager.instance.purchaseTwoThousandFiveHundredSixty { success in }
    }
    
    func elevenThousand() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let sequens = SKAction.sequence([fadeOut, fadeIn])
        
        threeCoins.run(sequens)
        
        PurchaseManager.instance.purchaseElevenThousandEightHunderdThitry { success in }
    }
    
    func restoreIAP() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let sequens = SKAction.sequence([fadeOut, fadeIn])
        
        restorePurchase.run(sequens)
        
        PurchaseManager.instance.restorePurchase { success in }
    }
}









