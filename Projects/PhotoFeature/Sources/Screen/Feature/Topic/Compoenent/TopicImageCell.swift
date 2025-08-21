//
//  TopicImageCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class TopicImageCell: BaseCollectionViewCell, CellIdentifialble {

    private let imageView = UIImageView()

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    override func addAttributes() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    override func addChild() {
        contentView.addSubview(imageView)
    }

    override func addLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setImage(model: TopicPhotoModel?) {
        guard let model else { return }
        if let url = URL(string: model.urls.regular ?? "") {
            let width = (UIScreen.main.bounds.width / 2) - 16
            imageView.kf.downSizingImage(url: url, size: CGSize(width: width, height: width * 1.2))
        }
    }
}
