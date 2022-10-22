//
//  Bookmarkable.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import Foundation

protocol Bookmarkable: AnyObject {
    func addBookmarkIfnotCreate(_ object: Decodable)
}
