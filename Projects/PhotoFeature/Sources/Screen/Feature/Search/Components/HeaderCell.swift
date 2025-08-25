//
//  HeaderCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class HeaderCell: BaseCollectionViewCell, CellIdentifialble {
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private(set) var likeButton = UIButton()
    
    override func addAttributes() {
        avatarView.backgroundColor = .secondarySystemBackground
        avatarView.layer.cornerRadius = 16
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.textColor = .secondaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular)
        likeButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        likeButton.setPreferredSymbolConfiguration(config, forImageIn: .selected)
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .systemBlue
        likeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addChild() {
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 32),
            avatarView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func set(profileURL: String, name: String, date: String, liked: Bool) {
        if let url = URL(string: profileURL) {
            avatarView.kf.downSizingImage(url: url, size: CGSize(width: 100, height: 100))
        }
        nameLabel.text = name
        dateLabel.text = date
        likeButton.isSelected = liked
    }
}
