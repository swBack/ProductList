//
//  Initialization.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

protocol Initializatable {
    var banners: [any BannerModelable] {get}
    var goods: [any GoodsModelable] {get}
}

struct Initialization: Decodable, Initializatable {
    var banners: [any BannerModelable]
    var goods: [any GoodsModelable]
    
    enum CodingKeys: CodingKey {
        case banners
        case goods
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.banners = (try? container.decodeIfPresent([Banner].self, forKey: .banners)) ?? [Banner]()
        self.goods = (try? container.decodeIfPresent([Goods].self, forKey: .goods)) ?? [Goods]()
    }
}

struct MockInitialization: Initializatable {
    private(set) var banners: [any BannerModelable]
    private(set) var goods: [any GoodsModelable]
    
    private init(banners: [any BannerModelable], goods: [any GoodsModelable]) {
        self.banners = banners
        self.goods = goods
    }
    
    static func createMockData() -> Initializatable {
        let banners = MockBanner.createMocks()
        let goods = MockGoods.createMocks()
        return MockInitialization(banners: banners, goods: goods)
    }
}
