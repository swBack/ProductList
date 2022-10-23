//
//  DatabaseStore.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/23.
//

import Foundation
import RealmSwift

protocol DatabaseWritable {
    associatedtype Database
    var readWriteDatabase: Database? { get }
    
    func save<ObjectModel: Object>(_ object: ObjectModel) throws
    func delete<ObjectModel: Object>(_ object: ObjectModel) throws
}

protocol DatabaseReadable {
    associatedtype Database
    var readDatabase: Database? { get }
    
    func load<ObjectModel: Object>(filter: String) -> Results<ObjectModel>?
}


class DatabaseStore: DatabaseWritable, DatabaseReadable {
    typealias Database = Realm
    static let standard = DatabaseStore()
    private(set) var readWriteDatabase: Database? = try? Database()
    private(set) var readDatabase: Database? = try? Database()
    
    func delete<ObjectModel: Object>(_ object: ObjectModel) throws {
        do {
            try readWriteDatabase?.write {
                self.readWriteDatabase?.delete(object)
            }
        } catch {
            throw error
        }
    }
        
    func load<ObjectModel: Object>(filter: String) -> Results<ObjectModel>? {
        let models = readDatabase?.objects(ObjectModel.self).filter(filter)
        return models
    }
    
    func save<ObjectModel: Object>(_ object: ObjectModel) throws {
        do {
            try readWriteDatabase?.write {
                self.readWriteDatabase?.add(object)
            }
        } catch {
            throw error
        }
    }
}


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
