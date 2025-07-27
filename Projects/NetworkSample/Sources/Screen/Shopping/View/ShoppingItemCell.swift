//
//  ShoppingResultCell.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import Kingfisher

final class ShoppingItemCell: BaseCollectionViewCell, CellIdentifialble {
    
    private let imageContainerView = UIView()
    private let shoppingImageView = UIImageView()
    private let likeButton = UIButton()
    private let imageLabel = UILabel()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    
    override func addChild() {
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(shoppingImageView)
        imageContainerView.addSubview(likeButton)
        contentView.addSubview(imageLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
    }
    
    override func addAttributes() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        shoppingImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.clipsToBounds = true
        
        shoppingImageView.contentMode = .scaleAspectFill
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.backgroundColor = .white
        likeButton.layer.cornerRadius = 18
        likeButton.clipsToBounds = true
        
        imageLabel.font = .systemFont(ofSize: 12, weight: .thin)
        imageLabel.textColor = .secondaryLabel
        imageLabel.numberOfLines = 1
        imageLabel.textAlignment = .left
        
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.lineBreakStrategy = .hangulWordPriority
        titleLabel.baselineAdjustment = .alignBaselines
        titleLabel.contentMode = .bottom
        
        priceLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        priceLabel.numberOfLines = 1
        priceLabel.textAlignment = .left
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 1.0),
            
            shoppingImageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            shoppingImageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            shoppingImageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            shoppingImageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -12),
            likeButton.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 36),
            likeButton.heightAnchor.constraint(equalToConstant: 36),
            
            imageLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            imageLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            imageLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            priceLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shoppingImageView.kf.cancelDownloadTask()
    }
    
    func configureCell(with shoppingItem: ShoppingItemDTO) {
        if let url = URL(string: shoppingItem.image) {
            let width = UIScreen.main.bounds.width / 2 - 16
            shoppingImageView.kf.downSizingImage(
                url: url,
                size: CGSize(
                    width: width,
                    height: width
                )
            )
        }
        imageLabel.text = shoppingItem.mallName
        let attributed = shoppingItem.title.htmlStringToAttributedString()
        titleLabel.attributedText = attributed ?? NSAttributedString(string: "N/A")
        priceLabel.text = shoppingItem.lprice.isEmpty ? "N/A" : Int(shoppingItem.lprice)!.formattedNumber()
    }
}
