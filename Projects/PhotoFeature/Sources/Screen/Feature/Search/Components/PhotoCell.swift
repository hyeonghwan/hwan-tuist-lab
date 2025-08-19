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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        photoImageView.kf.cancelDownloadTask()
    }
    
    override func addAttributes() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        self.photoImageView.kf.indicatorType = .activity
    }
    
    override func addChild() {
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(capsuleView)
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        capsuleView.translatesAutoresizingMaskIntoConstraints = false
        
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
        ])
    }
    
    func configure(photoModel: PhotoModel) {
        if let url = URL(string: photoModel.regularURL) {
            setImage(url: url, key: photoModel.id)
        }
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

final class CapsuleView: BaseView {
    private let startView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private(set) var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .thin)
        label.textColor = .white
        return label
    }()
    
    override func addAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.3)
        self.layer.cornerRadius = 12
    }
    
    override func addChild() {
        self.addSubview(startView)
        self.addSubview(likeCountLabel)
        
        startView.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addLayout()
    }
    
    private func addLayout() {
        startView.setContentHuggingPriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            startView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            startView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            startView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            startView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            likeCountLabel.leadingAnchor.constraint(equalTo: startView.trailingAnchor, constant: 4),
            likeCountLabel.centerYAnchor.constraint(equalTo: startView.centerYAnchor),
            likeCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6)
        ])
    }
}
