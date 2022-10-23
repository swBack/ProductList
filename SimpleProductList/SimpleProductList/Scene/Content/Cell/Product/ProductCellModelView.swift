//
//  ProductCellModelView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/23.
//

import Foundation
import RealmSwift

class ProductCellModelView: Hashable, Identifiable, Bookmarkable {
    static func == (lhs: ProductCellModelView, rhs: ProductCellModelView) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: UUID = UUID()
    private(set) var model: GoodsModelable?

    @Published private(set) var name: String = ""
    @Published private(set) var isNew: Bool = false
    @Published private(set) var showSellingStatus: Bool = false
    @Published private(set) var sellCounts: Int = 0
    @Published private(set) var discountRate: String = ""
    @Published private(set) var price: String = ""
    @Published private(set) var imageURL: URL?
    @Published private(set) var isSelected: Bool = false
    
    private(set) var modelType: TabType = .home
    
    init(_ model: any GoodsModelable, modelType: TabType) {
        self.modelType = modelType
        self.model = model
    }

    init() { }
    
    func updateModelView(target: ProductCellModelView) {
        self.model = target.model
        
        guard let model else {return}
        self.name = model.name
        self.isNew = model.is_new
        self.showSellingStatus = (model.sell_count) < 10
        self.sellCounts = model.sell_count
        self.price = model.price.toNumberString()
        self.discountRate = model.price.toDisscountRate(of: model.actual_price)
        self.imageURL = model.image
        self.modelType = target.modelType
        
        let fetch: Results<GoodsDbModel>? = DatabaseStore.standard.load(filter: "userDatabaseId = \(Int.max) AND id = \(model.id)")
        self.isSelected = !(fetch?.isEmpty ?? true)
    }
    
    func addBookmarkIfnotCreate(_ object: GoodsModelable?) throws {
        guard let object else {return}
        
        let fetch: Results<GoodsDbModel>? = DatabaseStore.standard.load(filter: "userDatabaseId = \(Int.max) AND id = \(object.id)")
        
        do {
            if let fetch = fetch?.first {
                try DatabaseStore.standard.delete(fetch)
            } else {
                try DatabaseStore.standard.save(GoodsDbModel(model: object))
            }
        } catch {
            throw error
        }
        
    }
}
