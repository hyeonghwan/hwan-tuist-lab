//
//  Cell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import Kingfisher

final class PhotoImageCell: BaseCollectionViewCell, CellIdentifialble {
    private let imageView = UIImageView()
    
    override func addAttributes() {
        imageView.backgroundColor = .tertiarySystemFill
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addChild() {
        contentView.addSubview(imageView)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setImage(urlString: String) {
        if let url = URL(string: urlString) {
            self.imageView.kf.setImage(with: .network(KF.ImageResource(downloadURL: url)))
        }
    }
}
