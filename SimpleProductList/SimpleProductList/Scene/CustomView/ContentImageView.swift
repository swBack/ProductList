//
//  ContentImageView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import Combine

class ContentImageView: UIView {
    private var subscription = Set<AnyCancellable>()
    private(set) var imageView: UIImageView = UIImageView()
    private let modelView = ContentImageModelView()
    
    private var shadowView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return view
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.custom_pink), for: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addPublished()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        self.bookmarkButton.isSelected = false
        self.imageView.image = nil
        self.imageView.cancelURLImageLoad()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true

        self.addSubview(imageView)
        self.addSubview(shadowView)
        self.addSubview(bookmarkButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.top.equalTo(self.snp_topMargin).offset(-8)
            make.trailing.equalTo(self.snp_trailingMargin).offset(8)
        }
    }
    
    private func addPublished() {
        modelView.$type
            .receive(on: DispatchQueue.main)
            .sink {[weak self] tabType in
            self?.bookmarkButton.isHidden = tabType == .bookmark
        }.store(in: &subscription)
    }
    
    func setContent(_ type: TabType) {
        modelView.setType(type)
    }
    
    func setImageURL(_ imageURL: URL) {
        self.imageView.setURLImage(url: imageURL)
    }
}

final class ContentImageModelView {
    @Published var type: TabType = .home
    var model: GoodsModelable?
    
    func setType(_ type: TabType) {
        self.type = type
    }
}
