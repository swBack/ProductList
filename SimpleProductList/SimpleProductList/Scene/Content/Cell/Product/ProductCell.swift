//
//  ProductCell.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import SnapKit
import Combine

protocol ProductCellConfigurable: UICollectionViewCell {
    func setupData(_ modelview: ProductCellModelView)
    func setContentType(_ modelType: TabType)
}

final class ProductCell: UICollectionViewCell, ProductCellConfigurable {
    static let reuseId = "ProductCell"
    private var subscription = Set<AnyCancellable>()
    private let modelView = ProductCellModelView()

    private let imageContentView: ContentImageView = ContentImageView()
    private let isNewProduct: NewTagView = NewTagView()

    private lazy var imageContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageContentView, UIView()])
        stackView.axis = .vertical
    
        imageContentView.snp.makeConstraints { make in
            make.width.equalTo(ProductCellSize.IMAGE_SIZE)
            make.height.equalTo(ProductCellSize.IMAGE_SIZE)
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
            make.height.equalTo(ProductCellSize.TAG_CONTAINER_HEIGHT)
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
            .map {
                $0.toNumberString() + "개 구매중"
            }
            .assign(to: \.text!, on: productStatus)
            .store(in: &subscription)
        
        self.modelView
            .$imageURL
            .sink(receiveValue: {[weak self] url in
                guard let self, let url else {return}
                self.imageContentView.setImageURL(url)
            })
            .store(in: &subscription)
        self.modelView
            .$isSelected
            .sink {[weak self] isSelected in
                self?.imageContentView.bookmarkButton.isSelected = isSelected
            }
            .store(in: &subscription)
        self.imageContentView
            .bookmarkButton
            .publisher(for: .touchUpInside)
            .sink {[weak self] sender in
                guard let self else {return}
                do {
                     try self.modelView.addBookmarkIfnotCreate(self.modelView.model)
                } catch {
                    
                }
            }.store(in: &subscription)
    }
    
    private func setupUI() {
        let contentStackView = UIStackView(arrangedSubviews: [priceContainer, descriptLabel, itemTagContainer])
        contentStackView.axis = .vertical
        contentStackView.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [imageContentStackView, contentStackView])
        stackView.axis = .horizontal
        stackView.spacing = ProductCellSize.BETWEEN_VIEW_PADDING
        
        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets(allPadding: ProductCellSize.PADDING))
        }
        priceContainer.snp.makeConstraints { make in
            make.height.equalTo(ProductCellSize.PRICE_CONTAINER_HEIGHT)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupData(_ modelview: ProductCellModelView) {
        self.modelView.updateModelView(target: modelview)
        
    }
    
    func setContentType(_ modelType: TabType) {
        self.imageContentView.setContent(modelType)
    }
}
