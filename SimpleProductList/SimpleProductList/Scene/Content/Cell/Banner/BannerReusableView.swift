//
//  BannerReusableView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import SnapKit
import Combine

final class BannerReusableView: UICollectionReusableView {
    static let reuseId = "BannerId"
    private var subscription = Set<AnyCancellable>()
    private var modelView: BannerReusableModelView!
    
    private lazy var bannerView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Int(self.frame.width), height: Int(self.frame.height))

        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseId)
        collectionview.isPagingEnabled = true
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
    }()
    
    private var pageLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var pageConainer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(pageLabel)
        view.layer.cornerRadius = 12

        pageLabel.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3))
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bannerView)
        self.addSubview(pageConainer)
        
        bannerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        pageConainer.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp_bottomMargin).offset(-8)
            make.trailing.equalTo(self.snp_trailingMargin).offset(-8)
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(45)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setBannerModel(_ model: [BannerModelable]) {
        self.modelView = BannerReusableModelView(bannerItem: model)
        addPublished()
        let page = Int(self.bannerView.contentOffset.x / self.frame.width) + 1
        self.modelView.updatePage(page)
        self.bannerView.reloadData()
    }
    
    private func addPublished() {
        self.modelView
            .$currentPage
            .map {
                "\($0)/\(self.modelView.bannerItem.count)"
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] text in
                self?.pageLabel.text = text
            })
            .store(in: &subscription)
        self.modelView
            .$currentPage
            .map {
                $0 <= 0
            }
            .receive(on: DispatchQueue.main)
            .sink {[weak self] isHideen in
                self?.pageConainer.isHidden = isHideen
            }
            .store(in: &subscription)
    }
}

extension BannerReusableView: CollectionDelegates, UICollectionViewDataSource, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = Int(scrollView.contentOffset.x / self.frame.width) + 1
        self.modelView.updatePage(offsetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(self.frame.width), height: Int(self.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelView.bannerItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
        cell.setBanner(modelView.bannerItem[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseId, for: indexPath) as! BannerCell
                cell.setBanner(modelView.bannerItem[indexPath.row])
            }
        }
    }
}
