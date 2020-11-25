//
//  AppPurchaseViewController.swift
//  Mp3Player
//
//  Created by MedOuber on 24/11/2020.
//  Copyright © 2020 MedOuber. All rights reserved.
//

import UIKit
import StoreKit

class AppPurchaseViewController: UIViewController , SKPaymentTransactionObserver{
   

    var pdts = [SKProduct]()
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var getGems: UIButton!
    @IBOutlet weak var noAdsLabl: UILabel!
    @IBOutlet weak var gemsLbl: UILabel!
    
    enum Product :String,CaseIterable {
        case removeAds = "com.pdt.removeAds"
        case subscribe = "com.pdt.subscribe"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doStockRequest()
        SKPaymentQueue.default().add(self)
        
    }
    
    private func doStockRequest() {
        let xx = Product.allCases.compactMap({ $0.rawValue })
        print("xx= \(xx)")
        let req = SKProductsRequest.init(productIdentifiers: Set(xx))
        req.delegate = self
        req.start()
        
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        let payment = SKPayment(product: self.pdts[0])
        SKPaymentQueue.default().add(payment)
    }
    
    @IBAction func getGemsBtnTapped(_ sender: Any) {
        
            let payment = SKPayment(product: self.pdts[1])
            SKPaymentQueue.default().add(payment)
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            
            
            switch $0.transactionState {
            
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("item purchased")
                SKPaymentQueue.default().finishTransaction($0)
                if $0.payment.productIdentifier == Product.removeAds.rawValue {
                    noAdsLabl.text = "NO Ads"
                }else {
                    gemsLbl.text = "30 gems"
                }
            case .failed:
                print("tr failed")
                SKPaymentQueue.default().finishTransaction($0)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
    
}

extension AppPurchaseViewController:SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.pdts = response.products
            if self.pdts.count > 0  {
                self.btn.setTitle(self.pdts[0].localizedTitle, for: .normal)
                self.getGems.setTitle(self.pdts[1].localizedTitle, for: .normal)
            }
        }
    }
    
    
    
    
    
}
