//
//  String+TextBoundSize.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/23.
//

import UIKit

extension String {
    func calculateStringHeight(defualtSize: CGFloat, maxWidthBound: CGFloat, font:UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        guard !self.isEmpty else {return defualtSize}
        let boundSize = CGSize(width: maxWidthBound, height: .greatestFiniteMagnitude)
        return NSString(string: self).boundingRect(with: boundSize,
                                                   options: .usesLineFragmentOrigin,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil).height
    }
}
