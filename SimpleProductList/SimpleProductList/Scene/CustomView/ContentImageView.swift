//
//  ContentImageView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit

class ContentImageView: UIView {
    private(set) var imageView: UIImageView = UIImageView()
    
    private var shadowView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        return view
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.custom_pink), for: .selected)
        button.addTarget(self, action: #selector(changedStatus(_ :)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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
    
    func setImageURL(_ imageURL: URL) {
        self.imageView.setURLImage(url: imageURL)
    }
    
    @objc private func changedStatus(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
