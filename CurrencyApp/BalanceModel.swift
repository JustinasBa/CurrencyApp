//
//  MainViewModel.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-21.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import Foundation
import SwiftyJSON

enum CurrencySymbol: String {
    case EUR
    case USD
    case JPY
    
    var symbol : String {
        switch self {
        case .EUR:
            return "€"
        case .USD:
            return "$"
        case .JPY:
            return "¥"
        }
    }
}

enum Currency: String {
    case EUR = "EUR"
    case USD = "USD"
    case JPY = "JPY"
}


struct CurrencyBalance: Any {
    
    var moneyAmount: Double
    var currency: String
    var currencySymbol: String?
    var commissionFee: Double
    
    init(currency: String, amount: Double, commissionFee: Double) {
        self.moneyAmount = amount
        self.currency = currency
        self.commissionFee = commissionFee
        if let _currencySymbol = CurrencySymbol(rawValue: currency)?.symbol {
             self.currencySymbol = _currencySymbol
        }
    }
}


class BalanceModel: NSObject {

    private let freeExhanges = 5
    private let commisionFeeRate = 0.007
    
    public var numberOfExchange = 0
    public var commissionFee: Double?
    public var holdingCurrency: [CurrencyBalance]?
    
    public var isFreeOfCommisionFee: Bool {
        return numberOfExchange <= freeExhanges
    }
    
    override init() {
        self.holdingCurrency = [ CurrencyBalance(currency: "EUR", amount: 1000.00, commissionFee: 0.00),
                                CurrencyBalance(currency: "USD", amount: 0.00, commissionFee: 0.00),
                                CurrencyBalance(currency: "JPY", amount: 0.00, commissionFee: 0.00) ]
        super.init()
    }
    
    private func exhange(fromAmount: Double, fromCurrency: String, toAmount: Double, toCurrency: String) {
        guard let fromCurr = Currency(rawValue: fromCurrency) else { return }
        guard let toCurr = Currency(rawValue: toCurrency) else { return }
        
        guard let fromWithAmount = holdingCurrency?[fromCurr.hashValue].moneyAmount else { return }
        guard let toWithAmount = holdingCurrency?[toCurr.hashValue].moneyAmount else { return }
        
        holdingCurrency?[fromCurr.hashValue].moneyAmount = fromWithAmount - fromAmount
        holdingCurrency?[toCurr.hashValue].moneyAmount = toWithAmount + toAmount
        
        numberOfExchange += 1
        
        guard !isFreeOfCommisionFee else { return }
        holdingCurrency?[fromCurr.hashValue].commissionFee += fromAmount * commisionFeeRate
        self.commissionFee = fromAmount * commisionFeeRate
    }
    
    public func exhangeCurrency(fromAmount: String, fromCurrency: String, toCurrency: String, callback: @escaping (Double) -> ()) {
        guard let _fromAmount = Double(fromAmount) else { return }
        
        API(APIRouter.exhangeCurrency(fromAmount, fromCurrency, toCurrency)) { json in
            guard json != JSON.null else { return }
            
            var toAmount: Double = 0
            if let amount = json["amount"].string {
                toAmount = Double(amount)!
            }
            self.exhange(fromAmount: _fromAmount, fromCurrency: fromCurrency, toAmount: toAmount, toCurrency: toCurrency)
            callback(toAmount)
        }
    }
    
    public func getExchangeRate(fromCurrency: String, toCurrency: String, callback: @escaping (String) -> ()) {
        API(APIRouter.exhangeRate(fromCurrency, toCurrency)) { json in
            guard json != JSON.null else {
                print("Failed to fetch Exchange Rate"); return }
            
            var toAmount = ""
            if let amount = json["amount"].string {
                toAmount = amount
            }
            callback(toAmount)
        }
    }
    
    public func getAmountOfMoney(item: Int) -> String {
        guard let currency = holdingCurrency?[item],
            let symbol = currency.currencySymbol else { return "" }
        
        let currencyString = "\(String(describing: symbol)) \(currency.moneyAmount)"
        

        return currencyString
    }
    
    public func getCurrencyWithAmount(forCurrency currency: Currency) -> CurrencyBalance {
        guard let currency = holdingCurrency?[currency.hashValue] else {
            return CurrencyBalance(currency: "EUR", amount: 0.00, commissionFee: 0.00)
        }
        
        return currency
    }
    
    public func commissionFeeText(ofCurrency item: Int) -> String {
        guard let fee = holdingCurrency?[item].commissionFee, !isFreeOfCommisionFee else {
            return "Kom. mokestis: 0.00"
        }
        return "Kom. mokestis: \(String(describing: fee))"
    }
    
    public func exchangeText(fromAmount: String, fromCurrency:String, toAmount: String, toCurrency: String) -> String {
        guard let fee = commissionFee, !isFreeOfCommisionFee else {
            return "Jūs konvertavote \(fromAmount) \(fromCurrency) į \(toAmount) \(toCurrency). Komisinis mokestis - 0.00 \(fromCurrency). (nemokamai)"
        }
        
        return "Jūs konvertavote \(fromAmount) \(fromCurrency) į \(toAmount) \(toCurrency). Komisinis mokestis - \(fee) \(fromCurrency). 0.7% komisinis mokestis"
    }
    
    public func currencyLabelText(currency item: Int) -> String {
        guard let currency = holdingCurrency?[item],
            let symbol = currency.currencySymbol else {
                return "Balance: 0.00" }
        
        let labelText = "Balance: \(String(describing: symbol))\(currency.moneyAmount)"
        
        return labelText
    }
    
    
        
    
}
