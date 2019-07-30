//
//  PurchaseManager.swift
//  OneTwo
//
//  Created by Carl Henningsson on 7/28/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

typealias CompletionHandler = (_ success: Bool) -> ()

import Foundation
import StoreKit

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let instance = PurchaseManager()
    
    let IAP_REMOVE_ADS = "com.hennngsson.OneTwo.RemoveAds"
    let IAP_FOUR_HUNDRET_TEN = "com.hennngsson.OneTwo.FourHundredTenCoins"
    let IAP_TWO_THOUSAND_FIVE_HUNDRED_SIXTY = "com.hennngsson.OneTwo.TwoThousandFiveHundredSixty"
    let IAP_ELEVEN_THOUSAND_EIGHT_HUNDRED_THIRTY = "com.hennngsson.OneTwo.ElevenThousandEightHundredThirty"
    
    var productsRequest: SKProductsRequest!
    var products = [SKProduct]()
    
    var transactionComplete: CompletionHandler?
    
    func purchaseRemoveAds(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let removeAds = products[2]
            let payment = SKPayment(product: removeAds)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func purchaseFourHundredTen(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let fourHundred = products[1]
            let payment = SKPayment(product: fourHundred)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func purchaseTwoThousandFiveHundredSixty(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            let twoThousand = products[3]
            let payment = SKPayment(product: twoThousand)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func purchaseElevenThousandEightHunderdThitry(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() && products.count > 0 {
            transactionComplete = onComplete
            let elevenThousand = products[0]
            let payment = SKPayment(product: elevenThousand)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            onComplete(false)
        }
    }
    
    func restorePurchase(onComplete: @escaping CompletionHandler) {
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            onComplete(false)
        }
    }
    
    func fetchProducts() {
        let productsIds = NSSet(objects: IAP_REMOVE_ADS, IAP_FOUR_HUNDRET_TEN, IAP_TWO_THOUSAND_FIVE_HUNDRED_SIXTY, IAP_ELEVEN_THOUSAND_EIGHT_HUNDRED_THIRTY) as! Set<String>
        productsRequest = SKProductsRequest(productIdentifiers: productsIds)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            print("Carl: SKPRodutc \(response.products)")
            products = response.products
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let transIds = transaction.payment.productIdentifier
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transIds == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    GameViewController.bannerView.removeFromSuperview()
                    transactionComplete?(true)
                } else if transIds == IAP_FOUR_HUNDRET_TEN {
                    setNewCoinValue(numberOfCoins: 410)
                    transactionComplete?(true)
                } else if transIds == IAP_TWO_THOUSAND_FIVE_HUNDRED_SIXTY {
                    setNewCoinValue(numberOfCoins: 2560)
                    transactionComplete?(true)
                } else if transIds == IAP_ELEVEN_THOUSAND_EIGHT_HUNDRED_THIRTY {
                    setNewCoinValue(numberOfCoins: 11830)
                    transactionComplete?(true)
                }
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionComplete?(false)
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                if transIds == IAP_REMOVE_ADS {
                    UserDefaults.standard.set(true, forKey: IAP_REMOVE_ADS)
                    GameViewController.bannerView.removeFromSuperview()
                    transactionComplete?(true)
                }
                break
            default:
                transactionComplete?(false)
                break
            }
        }
    }
    
    func setNewCoinValue(numberOfCoins: Int) {
        if let currentCoins = Int(MenuScene.numberOfCoins.text!) {
            let updatedCoins = currentCoins + numberOfCoins
            UserDefaults.standard.set(updatedCoins, forKey: "coins")
            MenuScene.numberOfCoins.text = "\(UserDefaults.standard.integer(forKey: "coins"))"
        }
    }
}

















