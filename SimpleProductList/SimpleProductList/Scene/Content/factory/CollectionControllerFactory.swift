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

    func createModelView() -> any Modelable {
        switch tabBarType {
        case .home:
            return ProductModelView(tabBarType)
        case .bookmark:
            return BookmarkModelView(tabBarType)
        }
    }    
}
