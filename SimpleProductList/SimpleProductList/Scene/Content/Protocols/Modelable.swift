//
//  Modelable.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation
import Combine

protocol Modelable: AnyObject {
    associatedtype Model
    var navigationTitle: String {get}
    var item: Model {get}
    var itemUpdatePublisher: PassthroughSubject<[GoodsModelView], Never> {set get}
    
    init(_ type: TabType)
    func initializeModelView()
    func fetchItem(_ lastId: Int?)
    func reload()
}

protocol Bannerable {
    var bannerItem: [BannerModelable] {get}
}
