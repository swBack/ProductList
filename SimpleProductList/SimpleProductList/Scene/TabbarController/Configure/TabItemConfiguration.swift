//
//  TabItemConfiguration.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit

protocol TabItemConfiguration {
    var name: String {get}
    var unSelectImage: UIImage? {get}
    var selectedImage: UIImage? {get}
    
    func createTabBarItem() -> UITabBarItem
}

extension TabItemConfiguration {
    func createTabBarItem() -> UITabBarItem {
        return UITabBarItem(title: name, image: unSelectImage, selectedImage: selectedImage)
    }
}
