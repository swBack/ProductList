//
//  BannerReusableModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation
import Combine

final class BannerReusableModelView {
    var bannerItem: [BannerModelable]
    @Published var currentPage: Int = 0
    
    init(bannerItem: [BannerModelable]) {
        self.bannerItem = bannerItem
    }
    
    func updatePage(_ page: Int) {
        if page != currentPage {
            self.currentPage = page
        }
    }
}
