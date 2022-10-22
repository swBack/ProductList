//
//  CollectionController.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/21.
//

import UIKit
import Combine
import SnapKit

extension CollectionControllerFactory {
    static func createController(type: TabType) -> UIViewController {
        let modelView = CollectionControllerFactory(tabBarType: type).createModelView()
        let vc = CollectionController(modelView)
        vc.tabBarItem = type.createTabBarItem()
        return vc
    }
}

typealias CollectionDelegates = UICollectionViewDelegate & UICollectionViewDataSourcePrefetching & UICollectionViewDelegateFlowLayout

fileprivate final class CollectionController: UIViewController {
    private enum Section {
        case content
    }
    
    private typealias CollectionViewDatasource = UICollectionViewDiffableDataSource<Section, GoodsModelView>
    private typealias CollectionViewSnapshot = NSDiffableDataSourceSnapshot<Section, GoodsModelView>
    private var subscripts = Set<AnyCancellable>()
    private(set) lazy var collectionView: UICollectionView = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didRefreshCollection(_:)), for: .valueChanged)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.refreshControl = refresh
        collectionView.register(ProductCell.self,
                                forCellWithReuseIdentifier: "ProductCell")
        collectionView.register(BannerReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: BannerReusableView.reuseId)
        return collectionView
    }()
    
    private lazy var datasource: CollectionViewDatasource = {
        let source = CollectionViewDatasource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
            cell.setupData(itemIdentifier)
            return cell
        }
        
        source.supplementaryViewProvider = {[weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self else {return nil}
            if let modelView = self.modelView as? ProductModelView {
                guard modelView.bannerItem.count > 0 else { return nil }
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: BannerReusableView.reuseId,
                                                                                 for: indexPath) as! BannerReusableView
                headerView.setBannerModel(modelView.bannerItem)
                return headerView
            }
            return nil
        }
        return source
    }()
    
    private let modelView: any Modelable
    
    init(_ modelView: any Modelable) {
        self.modelView = modelView
        super.init(nibName: nil, bundle: nil)
        addPublisher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = modelView.navigationTitle
        addCollectionView()
        modelView.initializeModelView()
    }
    
    private func addCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func addPublisher() {
        if let modelview = modelView as? ProductModelView {
            modelview.itemUpdatePublisher.eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .sink { newModel in
                self.performSnapshot(models: newModel)
            }.store(in: &subscripts)
        }
        
        if let modelview = modelView as? BookmarkModelView {
            modelview.itemUpdatePublisher.eraseToAnyPublisher().sink { newModel in
                
            }.store(in: &subscripts)
        }
    }
    
    private func performSnapshot(models: [GoodsModelView], animating: Bool = true) {
        var snapShot = CollectionViewSnapshot()
        snapShot.appendSections([.content])
        snapShot.appendItems(models)
        datasource.apply(snapShot, animatingDifferences: animating)
    }
    
    @objc private func didRefreshCollection(_ refreshControl: UIRefreshControl) {
        self.modelView.reload()
    }
}

extension CollectionController: CollectionDelegates {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}
