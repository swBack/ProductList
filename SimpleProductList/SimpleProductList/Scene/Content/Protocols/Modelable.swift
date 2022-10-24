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
