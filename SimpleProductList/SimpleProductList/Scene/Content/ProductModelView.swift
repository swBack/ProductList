//
//  ProductModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import Foundation
import Combine

final class ProductModelView: Modelable, Bannerable, Bookmarkable {
    typealias Model = [GoodsModelable]
    
    var navigationTitle: String
    private(set) var item: Model = []
    private(set) var bannerItem: [BannerModelable] = []
    
    var itemUpdatePublisher = PassthroughSubject<[GoodsModelView], Never>()
    
    required init(_ type: TabType) {
        self.navigationTitle = type.name
    }
    
    func initializeModelView() {
        Task {
            let result: Initialization = try await HTTPService().request(HTTPInitialization.initialize.urlRequest)
            let cellModelViews:[GoodsModelView] = result.goods.compactMap { GoodsModelView($0) }
            self.item = result.goods
            self.bannerItem = result.banners
            itemUpdatePublisher.send(cellModelViews)
        }
    }
    
    func fetchItem(_ lastId: Int? = nil) {
        
    }
    
    func reload() {
        
    }
    
    func addBookmarkIfnotCreate(_ object: Decodable) {
        
    }
}
