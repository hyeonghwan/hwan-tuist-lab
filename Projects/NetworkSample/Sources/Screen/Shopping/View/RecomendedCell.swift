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
        recommededImageView.contentMode = .scaleAspectFit
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            recommededImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recommededImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recommededImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommededImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell(with image: String) {
        if let url = URL(string: image) {
            recommededImageView.kf.downSampling(
                url: url,
                size: CGSize(width: 150, height: 150)
            )
        }
    }
}
