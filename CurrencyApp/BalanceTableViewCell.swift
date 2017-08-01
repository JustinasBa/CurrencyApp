//
//  BalanceTableViewCell.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-21.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyAmountLabel: UILabel!
    @IBOutlet weak var commisionFeeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func assignValue(forFee fee: String) {
        commisionFeeLabel.text = fee
    }
    
    public func assignValue(forAmountOfMoney number: String) {
        moneyAmountLabel.text = number
    }
    
}
