//
//  Int+format.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

extension Int {
    func toNumberString() -> String {
        let numberfmt = NumberFormatter()
        numberfmt.numberStyle = .decimal
        return numberfmt.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func toDisscountRate(of value: Int) -> String {
        let value = 100 - (self * 100 / value)
        return value > 0 ? "\(value)%":"0%"
    }
}
