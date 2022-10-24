//
//  GoodsDbModel.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/24.
//

import Foundation
import RealmSwift

class GoodsDbModel: Object, GoodsModelable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userDatabaseId: Int = Int.max
    @Persisted var name: String = ""
    @Persisted var imageURL: String = ""
    @Persisted var actual_price: Int = 0
    @Persisted var price: Int = 0
    @Persisted var is_new: Bool = false
    @Persisted var sell_count: Int = 0
    var image: URL {
        if imageURL.isEmpty {
            return URL(string: "https://")!
        }
        return URL(string: imageURL)!
    }
    
    override init() {
        super.init()
    }
    
    init(model: GoodsModelable) {
        self.name = model.name
        self.imageURL = model.image.absoluteString
        self.actual_price = model.actual_price
        self.price = model.price
        self.is_new = model.is_new
        self.sell_count = model.sell_count
        super.init()
        self.id = model.id
    }
}
