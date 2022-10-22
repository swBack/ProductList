//
//  TabType.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import UIKit

@frozen enum TabType {
    case home
    case bookmark
}

extension TabType: TabItemConfiguration {
    var name: String {
        switch self {
        case .home:
            return "홈"
        case .bookmark:
            return "좋아요"
        }
    }

    var unSelectImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        case .bookmark:
            return UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.gray)
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        case .bookmark:
            return UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.red)
        }
    }
}
