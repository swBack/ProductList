//
//  ProductModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import Foundation
import Combine

protocol Fetchable {
    var isLastItem: Bool {get}
    var isFetching: Bool {get}
}

final class ProductModelView: Modelable, Bannerable, Fetchable {
    typealias Model = [GoodsModelable]
    
    var navigationTitle: String = TabType.home.name
    private(set) var item: Model = []
    private(set) var bannerItem: [BannerModelable] = []
    private(set) var type: TabType = .home
    var itemUpdatePublisher = PassthroughSubject<SnapshotItem, Never>()
    private(set) var isLastItem: Bool = false
    private(set) var isFetching: Bool = false

    func initializeModelView() {
        Task {
            do {
                let result: Initialization = try await HTTPService().request(HTTPInitialization.initialize.urlRequest)
                let cellModelViews:[ProductCellModelView] = result.goods.compactMap { ProductCellModelView($0, modelType: .home) }
                self.item = result.goods
                self.bannerItem = result.banners
                itemUpdatePublisher.send(SnapshotItem(model: cellModelViews, isReset: true))
            } catch {
                SystemAlert().showAlertController(title: "Warning",
                                                  message: error.localizedDescription)
            }
        }
    }
    
    func fetchItem(_ lastId: Int? = nil) {
        guard let lastId, !isFetching, !isLastItem else {return}
        self.isFetching = true
        
        Task {
            do {
                let result: Pagingnation = try await HTTPService().request(Pagination.fetch(lastId).urlRequest)
                self.isFetching = false
                
                if result.goods.isEmpty {
                    self.isLastItem = true
                    return
                }
                
                self.item.append(contentsOf: result.goods)
                let cellModelViews:[ProductCellModelView] = self.item.compactMap { ProductCellModelView($0, modelType: .home) }
                itemUpdatePublisher.send(SnapshotItem(model: cellModelViews, isReset: false))
            } catch {
                SystemAlert().showAlertController(title: "Warning",
                                                  message: error.localizedDescription)
            }
        }
    }
    
    func reload() async {
        self.initializeModelView()
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
