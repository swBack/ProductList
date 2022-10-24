//
//  CollectionControllerFactory.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import UIKit

struct CollectionControllerFactory {
    private let tabBarType: TabType
    
    init(tabBarType: TabType) {
        self.tabBarType = tabBarType
    }

    private func createModelView() -> any Modelable {
        switch tabBarType {
        case .home:
            return ProductModelView()
        case .bookmark:
            return BookmarkModelView()
        }
    }
    
    static func createController(type: TabType) -> UIViewController {
        let modelView = CollectionControllerFactory(tabBarType: type).createModelView()
        let vc = CollectionController(modelView)
        vc.tabBarItem = type.createTabBarItem()
        return vc
    }
}
