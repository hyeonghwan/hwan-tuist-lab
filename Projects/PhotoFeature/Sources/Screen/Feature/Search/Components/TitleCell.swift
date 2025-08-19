//
//  TitleCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class TitleCell: BaseCollectionViewCell, CellIdentifialble {
    private let titleLabel = UILabel()
    
    override func addAttributes() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
    }
    
    override func addChild() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func set(text: String) {
        titleLabel.text = text
    }
}
