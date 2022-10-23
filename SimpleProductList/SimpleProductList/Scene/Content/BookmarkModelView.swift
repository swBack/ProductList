//
//  BookmarkModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import Foundation
import Combine
import RealmSwift

final class BookmarkModelView: Modelable, Fetchable {
    typealias Model = [GoodsModelable]
    
    private(set) var type: TabType = .bookmark
    private(set) var navigationTitle: String = TabType.bookmark.name
    private(set) var item: Model = []
    private(set) var isLastItem: Bool = false
    private(set) var isFetching: Bool = false
    
    var itemUpdatePublisher = PassthroughSubject<SnapshotItem, Never>()
        
    func initializeModelView() {
        let model: Results<GoodsDbModel>? = DatabaseStore.standard.load(filter: "userDatabaseId = \(Int.max)")
        let sorted = model?.sorted(by: { $0.id < $1.id })
        let cellModelViews:[ProductCellModelView] = model?.compactMap { ProductCellModelView($0, modelType: .bookmark) } ?? []
        self.item = sorted?.compactMap({ $0 }) ?? []
        itemUpdatePublisher.send(SnapshotItem(model: cellModelViews, isReset: true))
    }
    
    func fetchItem(_ lastId: Int? = nil) {
        
    }
    
    func reload() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                self.initializeModelView()
                continuation.resume()
            }
        }
    }
}
