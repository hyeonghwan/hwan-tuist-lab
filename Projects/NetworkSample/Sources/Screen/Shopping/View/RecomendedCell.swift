//
//  RecomendedCell.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class RecomendedCell: BaseCollectionViewCell, CellIdentifialble {
    private let recommededImageView = UIImageView()
    
    override func addChild() {
        contentView.addSubview(recommededImageView)
    }
    
    override func addAttributes() {
        recommededImageView.contentMode = .scaleAspectFill
        recommededImageView.translatesAutoresizingMaskIntoConstraints = false
        recommededImageView.layer.cornerRadius = 12
        recommededImageView.clipsToBounds = true
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            recommededImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            recommededImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            recommededImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            recommededImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureCell(with image: String) {
        if let url = URL(string: image) {
            recommededImageView.kf.downSampling(
                url: url,
                size: CGSize(width: 120, height: 120)
            )
        }
    }
}
