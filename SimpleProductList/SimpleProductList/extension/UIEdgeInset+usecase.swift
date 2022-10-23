//
//  UIEdgeInset+usecase.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/23.
//

import UIKit

extension UIEdgeInsets {
    init(allPadding: CGFloat) {
        self.init(top: allPadding, left: allPadding, bottom: allPadding, right: allPadding)
    }
}
