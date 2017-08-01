////
////  ExhangeMessageView.swift
////  CurrencyApp
////
////  Created by Justinas Baronas on 2017-07-31.
////  Copyright © 2017 Justinas Baronas. All rights reserved.
////
//
//import UIKit
//
//class ExchangeMessageViewController: UIViewController {
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let exchangeMessageAlert = UIAlertController(title: nil, message: "Choose currency: ", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.dismiss(animated: true, completion: nil)
//        }))
//        
//        let currenciesOptions = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
//        
//        
//        for module in 0..<holdingCurrencies.count {
//            let currency = holdingCurrencies[module].currency
//            
//            currenciesOptions.addAction(UIAlertAction(title: currency, style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                button.setTitle(currency ,for: .normal)
//                label.text = self.balanceModule?.currencyLabelText(fromCurrencies: module)
//                self.setExchangeRate()
//            }))
//            
//        }
//
//        exchangeMessageAlert.addAction(okAction)
//        
//        self.present(exchangeMessageAlert, animated: true, completion: nil)
//    }
//    
//}
