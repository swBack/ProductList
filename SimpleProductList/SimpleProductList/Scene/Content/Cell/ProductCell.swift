//
//  ProductCell.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import SnapKit
import Combine

class ProductCell: UICollectionViewCell {
    private var subscription = Set<AnyCancellable>()
    private let modelView = GoodsModelView()
    
    private let imageContentView: ContentImageView = ContentImageView()
    private let isNewProduct: NewTagView = NewTagView()

    private lazy var imageContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContentView, UIView()])
        stackView.axis = .vertical
        
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        return stackView
    }()
    
    private lazy var priceContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [discountRateLabel, priceLabel, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private var discountRateLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = UIColor.custom_pink
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    
    private var priceLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = UIColor.text_primary
        label.font = UIFont.boldSystemFont(ofSize: 23)
        return label
    }()
    
    private var descriptLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = UIColor.text_secondary
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
        
    private lazy var productStatus: UILabel = {
       let label = UILabel()
        label.text = ""
        label.textColor = UIColor.text_secondary
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var itemTagContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [isNewProduct, productStatus, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 8
        isNewProduct.snp.makeConstraints { make in
            make.width.equalTo(45)
            make.height.equalTo(24)
        }
        return stackView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageContentView.prepareForReuse()
        [descriptLabel, discountRateLabel, priceLabel, productStatus].forEach({ $0.text = "" })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addPublisher()
    }
    
    private func addPublisher() {
        self.modelView
            .$name
            .assign(to: \.text!, on: descriptLabel)
            .store(in: &subscription)
        
        self.modelView
            .$discountRate
            .assign(to: \.text!, on: discountRateLabel)
            .store(in: &subscription)
        
        self.modelView
            .$price
            .assign(to: \.text!, on: priceLabel)
            .store(in: &subscription)
        
        self.modelView
            .$isNew
            .assign(to: \.isHidden, on: isNewProduct)
            .store(in: &subscription)
        
        self.modelView
            .$showSellingStatus
            .assign(to: \.isHidden, on: productStatus)
            .store(in: &subscription)
        
        self.modelView
            .$sellCounts
            .assign(to: \.text!, on: productStatus)
            .store(in: &subscription)
        
        self.modelView
            .$imageURL
            .sink(receiveValue: {[weak self] url in
                guard let self, let url else {return}
                self.imageContentView.setImageURL(url)
            })
            .store(in: &subscription)
    }
    
    private func setupUI() {
        let contentStackView = UIStackView(arrangedSubviews: [priceContainer, descriptLabel, itemTagContainer])
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [imageContentStackView, contentStackView])
        stackView.axis = .horizontal
        stackView.spacing = 18
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18))
        }
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ modelview: GoodsModelView) {
        self.modelView.updateModelView(target: modelview)
    }
}
