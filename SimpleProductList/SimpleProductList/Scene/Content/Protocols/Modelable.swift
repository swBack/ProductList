//
//  Modelable.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import Combine

protocol Modelable: AnyObject {
    associatedtype Model
    var navigationTitle: String {get}
    var item: Model {get}
    var itemUpdatePublisher: PassthroughSubject<SnapshotItem, Never> {set get}
    var type: TabType {get}
    
    func initializeModelView()
    func fetchItem(_ lastId: Int?)
    func reload() async
    
    func calculateCellSize(indexPath: IndexPath, cellWidth: CGFloat) -> CGSize
}

extension Modelable {
    func calculateCellSize(indexPath: IndexPath, cellWidth: CGFloat) -> CGSize {
        guard ((self.item as? [GoodsModelable])?.count) ?? 0 > indexPath.row else { return .zero }
        
        let contentWidth = cellWidth - ProductCell.ProductCellSize.IMAGE_SIZE - (ProductCell.ProductCellSize.PADDING * 2) - ProductCell.ProductCellSize.BETWEEN_VIEW_PADDING
        let name = (self.item as? [GoodsModelable])?[indexPath.row].name ?? ""
        let descrpitionContainer: CGFloat = name.calculateStringHeight(defualtSize: 30, maxWidthBound: contentWidth)
        let contentHeight = descrpitionContainer + ProductCell.ProductCellSize.IMAGE_SIZE + ProductCell.ProductCellSize.PRICE_CONTAINER_HEIGHT + ProductCell.ProductCellSize.TAG_CONTAINER_HEIGHT
        
        return CGSize(width: cellWidth, height: contentHeight)
    }
}
