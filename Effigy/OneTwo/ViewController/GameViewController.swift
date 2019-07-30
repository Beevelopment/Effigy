//
//  GameViewController.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/22/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds
import AVFoundation

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {

    static var bannerView: GADBannerView!
    static var interstitial: GADInterstitial!
    
    static var avAudioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: view.bounds.size)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
        }
        playBackgroundSound()
        
        if !UserDefaults.standard.bool(forKey: PurchaseManager.instance.IAP_REMOVE_ADS) {
            setupBannerAds()
        }
        
        GameViewController.interstitial = createAndLoadInterstitial()
    }
    
    func setupBannerAds() {
        GameViewController.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        GameViewController.bannerView.frame = CGRect(x: view.frame.midX - 160, y: view.frame.height - 75, width: 320, height: 50)
        GameViewController.bannerView.adUnitID = "ca-app-pub-6662079405759550/3789899916"
        GameViewController.bannerView.rootViewController = self
        GameViewController.bannerView.load(GADRequest())
        GameViewController.bannerView.delegate = self
        
        view.addSubview(GameViewController.bannerView)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6662079405759550/4472426192")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        GameViewController.interstitial = createAndLoadInterstitial()
    }
}
