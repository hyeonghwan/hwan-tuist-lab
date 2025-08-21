//
//  PhotoCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import Kingfisher

final class PhotoCell: BaseCollectionViewCell, CellIdentifialble {
    private let photoImageView = UIImageView()
    private let capsuleView = CapsuleView()
    private(set) var likeButton = UIButton()
    var action: ((Bool) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        likeButton.isSelected = false
        action = nil
        photoImageView.kf.cancelDownloadTask()
    }
    
    override func addAttributes() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        self.photoImageView.kf.indicatorType = .activity
        
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
        likeButton.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        likeButton.setPreferredSymbolConfiguration(config, forImageIn: .selected)
        
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.layer.cornerRadius = 15
        likeButton.backgroundColor = .white.withAlphaComponent(0.3)
        
        self.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func addChild() {
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(capsuleView)
        self.contentView.addSubview(likeButton)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.bringSubviewToFront(capsuleView)
    }
    
    override func addLayout() {
        let height = capsuleView.heightAnchor.constraint(equalToConstant: 30)
        height.priority = .defaultLow
        height.isActive = true
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            capsuleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            capsuleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            
            likeButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            likeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc
    private func likeButtonTapped(_ sender: UIButton) {
        let origin = sender.isSelected
        sender.isSelected = !origin
        self.likeButton.tintColor = sender.isSelected ? .systemBlue : .white.withAlphaComponent(0.5)
        self.action?(!origin)
    }
    
    func configure(photoModel: PhotoModel) {
        if let url = URL(string: photoModel.regularURL) {
            setImage(url: url, key: photoModel.id)
        }
        self.likeButton.tintColor = photoModel.userLike ? .systemBlue : .white.withAlphaComponent(0.5)
        self.likeButton.isSelected = photoModel.userLike
        
        self.capsuleView.likeCountLabel.text = "\(photoModel.likes.formatted())"
    }
    
    func setImage(url: URL, key: String) {
        self.photoImageView.kf.setImage(
            with: .network(KF.ImageResource(downloadURL: url, cacheKey: key)),
            options: [
                .transition(.fade(0.3)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
