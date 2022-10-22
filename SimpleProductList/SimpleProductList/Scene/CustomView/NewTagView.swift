//
//  NewTagView.swift
//  SimpleProductList
//
//  Created by 백성우 on 2022/10/22.
//

import UIKit
import SnapKit

class NewTagView: UIView {
    private var label: UILabel = {
        let label = UILabel()
        label.text = "NEW"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6))
        }

        self.layer.cornerRadius = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.3
    }
}
