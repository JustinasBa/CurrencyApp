//
//  ExchangeHistoryTableViewCell.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-20.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import UIKit

class ExchangeHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exchangeMessageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        let result = formatter.string(from: date)
        dateLabel.text = result
    }
    
    public func assignValue(forExchangeMessage message: String) {
        exchangeMessageLabel.text = message
    }

    
}
