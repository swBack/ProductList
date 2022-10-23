//
//  BannerCell.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit

class BannerCell: UICollectionViewCell {
    static let reuseId = "BannerCellId"
    
    private var imageView = UIImageView()
    
    deinit {
        imageView.cancelURLImageLoad()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelURLImageLoad()
        imageView.image = nil
    }
    
    private func setupUI() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    func setBanner(_ banner: BannerModelable) {
        imageView.setURLImage(url: banner.image)
    }
}
