//
//  AudioPlayer.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/26/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import UIKit
import AVFoundation

extension GameViewController {
    
    func playBackgroundSound() {
        let path = Bundle.main.path(forResource: "Indie Kid", ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        
        do {
            try GameViewController.avAudioPlayer = AVAudioPlayer(contentsOf: soundUrl)
            GameViewController.avAudioPlayer.prepareToPlay()
        } catch let err as NSError {
            print(err.description)
        }
        
        if UserDefaults.standard.bool(forKey: "musicBool") {
            GameViewController.avAudioPlayer.play()
            GameViewController.avAudioPlayer.numberOfLoops = -1
        } else {
            GameViewController.avAudioPlayer.pause()
        }
    }
    
//    static func playSound(soundFileName: String) {
//        let path = Bundle.main.path(forResource: soundFileName, ofType: "mp3")
//        let soundUrl = URL(fileURLWithPath: path!)
//        
//        do {
//            try avAudioPlayer = AVAudioPlayer(contentsOf: soundUrl)
//            avAudioPlayer.prepareToPlay()
//        } catch let err as NSError {
//            print(err.description)
//        }
//        
//        if UserDefaults.standard.bool(forKey: "musicBool") {
//            avAudioPlayer.play()
//            avAudioPlayer.numberOfLoops = 0
//        } else {
//            avAudioPlayer.pause()
//        }
//    }
}
