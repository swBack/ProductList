//
//  BookmarkModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import Foundation
import Combine

final class BookmarkModelView: Modelable {
    typealias Model = [GoodsModelable]
    
    var navigationTitle: String
    private(set) var item: Model = []
    var itemUpdatePublisher = PassthroughSubject<[GoodsModelView], Never>()
    
    required init(_ type: TabType) {
        self.navigationTitle = type.name
    }
    
    func initializeModelView() {
        
    }
    
    func fetchItem(_ lastId: Int? = nil) {
        
    }
    
    func reload() {
        
    }
}
