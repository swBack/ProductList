//
//  MainTabController.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import UIKit

class MainTabController: UITabBarController {
    private var homeView: UIViewController = {
      return CollectionControllerFactory.createController(type: .home)
    }()
    
    private var bookmarkView: UIViewController = {
        return CollectionControllerFactory.createController(type: .bookmark)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setViewControllers([homeView, bookmarkView], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
}
