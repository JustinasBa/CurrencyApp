//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-20.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {

    @IBOutlet weak var balanceTableView: UITableView!
    @IBOutlet weak var goToExchangeButton: UIButton!
    
    public var balanceModel: BalanceModel = BalanceModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        balanceTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let exchangeViewController = segue.destination as? ExchangeViewController {
            exchangeViewController.balanceModule = balanceModel
        }
    }
    
    private func setupView() {
        balanceTableView.dataSource = self
        balanceTableView.delegate = self
        balanceTableView.register(UINib(nibName: "BalanceTableViewCell", bundle: nil), forCellReuseIdentifier: "BalanceTableViewCell")
        
        balanceTableView.layer.cornerRadius = kCornerUnit 
        balanceTableView.layer.borderColor = kColorGrey.cgColor
        balanceTableView.layer.borderWidth = 0.5
        
        goToExchangeButton.layer.cornerRadius = goToExchangeButton.frame.height / 2
        goToExchangeButton.backgroundColor = kColorGreen
    }
}

// MARK: - UITableViewDataSource

extension BalanceViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currenciesCount = balanceModel.holdingCurrency?.count else { return 0 }
        
        return currenciesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceTableViewCell", for: indexPath) as? BalanceTableViewCell else { return UITableViewCell() }
    
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BalanceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? BalanceTableViewCell {
            cell.assignValue(forAmountOfMoney: balanceModel.getAmountOfMoney(item: indexPath.row))
            cell.assignValue(forFee: balanceModel.commissionFeeText(ofCurrency: indexPath.row))
        }
}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
