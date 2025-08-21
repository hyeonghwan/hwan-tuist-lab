//
//  RetryCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class RetryCell: BaseCollectionViewCell, CellIdentifialble {
    private let retryImageView = UIImageView(image: UIImage(systemName: "arrow.clockwise"))

    override func addAttributes() {
        retryImageView.tintColor = .systemGray
        retryImageView.contentMode = .scaleAspectFit
    }
    
    override func addChild() {
        contentView.addSubview(retryImageView)
        retryImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            retryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            retryImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
