//
//  Banner.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

protocol BannerModelable {
    var id: Int {get}
    var image: URL {get}
}

struct Banner: Decodable, BannerModelable {
    var id: Int
    var image: URL
    
    enum CodingKeys: CodingKey {
        case id
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.image = try container.decode(URL.self, forKey: .image)
    }
}

struct MockBanner: BannerModelable {
    private(set) var image: URL
    private(set) var id: Int
    
    private init(image: URL, id: Int) {
        self.id = id
        self.image = image
    }
    
    static func createSimpleMock() -> [MockBanner] {
        return [MockBanner(image: URL(string: "https://img.a-bly.com/banner/images/banner_image_1615465448476691.jpg")!, id: 1)]
    }
    
    static func createMocks() -> [MockBanner] {
        return [MockBanner(image: URL(string: "https://img.a-bly.com/banner/images/banner_image_1615465448476691.jpg")!, id: 1),
                MockBanner(image: URL(string: "https://img.a-bly.com/banner/images/banner_image_1615970086333899.jpg")!, id: 2),
                MockBanner(image: URL(string: "https://img.a-bly.com/banner/images/banner_image_1615962899391279.jpg")!, id: 3)]
    }
}
