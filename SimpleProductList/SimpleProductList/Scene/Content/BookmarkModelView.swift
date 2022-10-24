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
    typealias Model = [ProductCellModelView]
    
    private(set) var type: TabType = .bookmark
    private(set) var navigationTitle: String = TabType.bookmark.name
    private(set) var item: Model = []
    private(set) var isLastItem: Bool = false
    private(set) var isFetching: Bool = false
    
    private var databaseObserver: NotificationToken?
    var itemUpdatePublisher = PassthroughSubject<SnapshotItem, Never>()
    
    init() {
        self.databaseObserver = DatabaseStore.standard.readWriteDatabase?.observe({ notification, realm in
            switch notification {
            case .didChange:
                self.initializeModelView()
            case .refreshRequired: break
            }
        })
    }
    
    func initializeModelView() {
        let model: Results<GoodsDbModel>? = DatabaseStore.standard.load(filter: "userDatabaseId = \(Int.max)")?.sorted(byKeyPath: "id")
        let cellModelViews:[ProductCellModelView] = model?.compactMap { ProductCellModelView($0, modelType: .bookmark) } ?? []
        self.item = cellModelViews
        itemUpdatePublisher.send(SnapshotItem(model: cellModelViews, isReset: true))
    }
    
    func fetchItem(_ lastId: Int? = nil) {
    }
    
    func reload() async {
        DispatchQueue.main.async {
            self.initializeModelView()
        }
    }
    
    func calculateCellSize(indexPath: IndexPath, cellWidth: CGFloat) -> CGSize {
        guard self.item.count > indexPath.row else { return .zero }
        
        let contentWidth = cellWidth - ProductCell.ProductCellSize.IMAGE_SIZE - (ProductCell.ProductCellSize.PADDING * 2) - ProductCell.ProductCellSize.BETWEEN_VIEW_PADDING
        let name = self.item[indexPath.row].name
        let descrpitionContainer: CGFloat = name.calculateStringHeight(defualtSize: 30, maxWidthBound: contentWidth)
        let contentHeight = descrpitionContainer + ProductCell.ProductCellSize.IMAGE_SIZE + ProductCell.ProductCellSize.PRICE_CONTAINER_HEIGHT + ProductCell.ProductCellSize.TAG_CONTAINER_HEIGHT
        
        return CGSize(width: cellWidth, height: contentHeight)
    }

}
