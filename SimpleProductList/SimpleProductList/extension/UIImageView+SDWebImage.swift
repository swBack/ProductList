//
//  UIImageView+SDWebImage.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import SDWebImage

extension UIImageView {
    func cancelURLImageLoad() {
        self.sd_cancelCurrentImageLoad()
    }
    
    func setURLImage(url: URL) {
        self.sd_setImage(with: url) { image, error, type, _ in
            self.image = image
        }
    }
}
