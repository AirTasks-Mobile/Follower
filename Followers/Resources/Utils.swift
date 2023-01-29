//
//  Utils.swift
//  Followers
//
//  Created by JEREMY NGUYEN on 12/01/2022.
//

import Foundation
struct Utils {
    static func formatNumber(num : String) -> String {
        if num == "" {
            return ""
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
                //formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1 // default
        formatter.maximumSignificantDigits = 18 // default
        let value = NSDecimalNumber(string: num)
    
        let numString = formatter.string(for: value) ?? ""
  
        return numString
    }
}
