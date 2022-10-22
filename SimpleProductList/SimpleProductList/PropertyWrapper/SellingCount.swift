//
//  SellingCount.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

@propertyWrapper
struct SellingCount {
    private var value: String = ""
    
    var wrappedValue: String {
        get {
            return self.value + "개 구매중"
        }
        set {
            self.value = newValue
        }
    }
 
    init(wrappedValue value: String) {
        self.wrappedValue = value
    }
}
