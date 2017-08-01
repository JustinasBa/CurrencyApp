//
//  ExchangeViewController.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-21.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var fromAmountTextField: UITextField!
    
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    
    @IBOutlet weak var exchangeButton: UIButton!
    
    public var balanceModule: BalanceModel?
    public let maxLenght = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fromAmountTextField.becomeFirstResponder()
        updateLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setExchangeRate()
    }
    
    private func setupView() {
        rateLabel.layer.cornerRadius = rateLabel.frame.height / 2
        rateLabel.layer.borderColor = kColorGrey.cgColor
        rateLabel.layer.borderWidth = 0.5
        
        exchangeButton.layer.cornerRadius = exchangeButton.frame.height / 2
        exchangeButton.backgroundColor = kColorGreen
        exchangeButton.tintColor = kColorWhite
        
        fromAmountTextField.delegate = self
        fromAmountTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    private func setExchangeRate() {
        guard let fromCurrency = fromButton.currentTitle else { return }
        guard let toCurrency = toButton.currentTitle else { return }
        guard let fromCurr = Currency(rawValue: fromCurrency) else { return }
        guard let toCurr = Currency(rawValue: toCurrency) else { return }
        guard let fromSymbol = balanceModule?.getCurrencyWithAmount(forCurrency: fromCurr).currencySymbol else { return }
        guard let toSymbol = balanceModule?.getCurrencyWithAmount(forCurrency: toCurr).currencySymbol else { return }
        
        balanceModule?.getExchangeRate(fromCurrency: fromCurrency, toCurrency: toCurrency, callback: { toAmount in
            self.rateLabel.text = "\(fromSymbol)1 = \(toSymbol)\(toAmount)"
        })
    }
    
    public func showCurrencyPicker(forButton button: UIButton, label: UILabel) {
        guard let holdingCurrencies = balanceModule?.holdingCurrency else { return }
        let currenciesOptions = UIAlertController(title: nil, message: "Choose currency: ", preferredStyle: .actionSheet)
        
        for module in 0..<holdingCurrencies.count {
            let currency = holdingCurrencies[module].currency
            
            currenciesOptions.addAction(UIAlertAction(title: currency, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                button.setTitle(currency ,for: .normal)
                label.text = self.balanceModule?.currencyLabelText(currency: module)
                self.setExchangeRate()
            }))
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        currenciesOptions.addAction(cancelAction)
        
        self.present(currenciesOptions, animated: true, completion: nil)
    }
    
    public func updateLabels() {
        guard let fromCurrency = fromButton.currentTitle else { return }
        guard let fromCurr = Currency(rawValue: fromCurrency) else { return }
        guard let toCurrency = toButton.currentTitle else { return }
        guard let toCurr = Currency(rawValue: toCurrency) else { return }
        self.fromCurrencyLabel.text = self.balanceModule?.currencyLabelText(currency: fromCurr.hashValue)
        self.toCurrencyLabel.text = self.balanceModule?.currencyLabelText(currency: toCurr.hashValue )
    }
    
    func myTextFieldDidChange(_ textField: UITextField) {
        guard  let amountString = textField.text?.currencyInputFormatting() else { return }
        textField.text = amountString
    }
}


// MARK: - IBActions

extension ExchangeViewController {
    
    @IBAction func showFromPicker(_ sender: Any) {
        showCurrencyPicker(forButton: fromButton, label: fromCurrencyLabel)
    }
    
    @IBAction func showToPicker(_ sender: Any) {
        showCurrencyPicker(forButton: toButton, label: toCurrencyLabel)
    }
    
    @IBAction func exhangeCurrency(_ sender: Any) {
        guard let amountToChange = fromAmountTextField.text , !amountToChange.isEmpty else { return }
        guard let fromCurrency = fromButton.currentTitle else { return }
        guard let fromCurr = Currency(rawValue: fromCurrency) else { return }
        guard let fromAmount = self.balanceModule?.getCurrencyWithAmount(forCurrency: fromCurr).moneyAmount,
            let amountDouble = Double(amountToChange),
            fromAmount >= amountDouble else { return }
        guard let toCurrency = toButton.currentTitle else { return }
        guard fromCurrency != toCurrency else { return }
        
        balanceModule?.exhangeCurrency(fromAmount: amountToChange, fromCurrency: fromCurrency, toCurrency: toCurrency, callback: { toAmount in
            let exhangeText = self.balanceModule?.exchangeText(fromAmount: amountToChange,
                                                               fromCurrency: fromCurrency,
                                                               toAmount: String(toAmount),
                                                               toCurrency: toCurrency)
            let exchangeMessageAlert = UIAlertController(title: nil, message: exhangeText, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
            exchangeMessageAlert.addAction(okAction)
            
            self.present(exchangeMessageAlert, animated: true, completion: nil)
            
            self.updateLabels()
        })

    }
}

// MARK: - UITextFieldDelegate

extension ExchangeViewController: UITextFieldDelegate {
    
    public func getWidth(text: String) -> CGFloat {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let maxWidth: CGFloat = 60
        
        let width = getWidth(text: text)
        if maxWidth > width {
            textField.frame.size.width = 0.0
            if width > textField.frame.size.width {
                textField.frame.size.width = width
            }
            self.view.layoutIfNeeded()
        }
        
        return newLength <= maxLenght // Bool
    }
}


