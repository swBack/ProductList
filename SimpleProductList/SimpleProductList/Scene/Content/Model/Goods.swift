//
//  Goods.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

protocol GoodsModelable {
    var id: Int {get}
    var name: String {get}
    var image: URL {get}
    var actual_price: Int {get}
    var price: Int {get}
    var is_new: Bool {get}
    var sell_count: Int {get}
}

struct Pagingnation: Decodable {
    var goods: [Goods]
    
    enum CodingKeys: CodingKey {
        case goods
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.goods = try container.decode([Goods].self, forKey: .goods)
    }
}
struct Goods: Decodable, GoodsModelable {
    var id: Int
    var name: String
    var image: URL
    var actual_price: Int
    var price: Int
    var is_new: Bool
    var sell_count: Int
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case image
        case actual_price
        case price
        case is_new
        case sell_count
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(URL.self, forKey: .image)
        self.actual_price = try container.decode(Int.self, forKey: .actual_price)
        self.price = try container.decode(Int.self, forKey: .price)
        self.is_new = try container.decode(Bool.self, forKey: .is_new)
        self.sell_count = (try? container.decodeIfPresent(Int.self, forKey: .sell_count)) ?? 0
    }
}

struct MockGoods: GoodsModelable {
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var image: URL
    private(set) var actual_price: Int
    private(set) var price: Int
    private(set) var is_new: Bool
    private(set) var sell_count: Int
    
    private init(id: Int,
         name: String,
         image: URL,
         actual_price: Int,
         price: Int,
         is_new: Bool,
         sell_count: Int) {
        self.id = id
        self.name = name
        self.image = image
        self.actual_price = actual_price
        self.price = price
        self.is_new = is_new
        self.sell_count = sell_count
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func createEmptyMock() -> [MockGoods] {
        return []
    }
    
    static func createSimpleMock() -> [MockGoods] {
        return [
            MockGoods(id: 1,
                      name: "[선물포장/별자리각인] 집들이 선물 원목 별자리 인센스 스틱 홀더 3type 호두나무 참나무 단풍나무 인테리어소품 감성소품 캠핑용품",
                      image: URL(string: "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210122_1611290798811044s.jpg")!,
                      actual_price: 18000,
                      price: 16000,
                      is_new: false,
                      sell_count: 61)
        ]
    }
    
    static func createMocks() -> [MockGoods] {
        [
            MockGoods(id: 1,
                      name: "[선물포장/별자리각인] 집들이 선물 원목 별자리 인센스 스틱 홀더 3type 호두나무 참나무 단풍나무 인테리어소품 감성소품 캠핑용품",
                      image: URL(string: "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210122_1611290798811044s.jpg")!,
                      actual_price: 18000,
                      price: 16000,
                      is_new: false,
                      sell_count: 61),
            MockGoods(id: 2,
                      name: "당일출고]왕박시핏! 스트링 야상 자켓;2col",
                      image: URL(string: "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210225_1614264987060340s.gif")!,
                      actual_price: 34000,
                      price: 34000,
                      is_new: false,
                      sell_count: 58),
            MockGoods(id: 3,
                      name: "[세트할인!]인기상품~벨치스 포켓 후드집업 + 피얼즈 골지스판 뷔스티에 원피스 세트상품",
                      image: URL(string: "https://d20s70j9gw443i.cloudfront.net/t_GOODS_THUMB_WEBP/https://imgb.a-bly.com/data/goods/20210305_1614930254984142s.gif")!,
                      actual_price: 35600,
                      price: 33900,
                      is_new: true,
                      sell_count: 61)
        ]
    }
}
