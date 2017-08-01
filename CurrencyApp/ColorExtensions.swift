//
//  ColorExtensions.swift
//  CurrencyApp
//
//  Created by Justinas Baronas on 2017-07-31.
//  Copyright © 2017 Justinas Baronas. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithHexString(_ hexString: String) -> UIColor {
        var hexString = hexString
        hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#")) {
            hexString = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 1))
        }
        
        if (hexString.characters.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

