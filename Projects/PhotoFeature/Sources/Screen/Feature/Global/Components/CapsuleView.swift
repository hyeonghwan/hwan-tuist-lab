//
//  CapsuleView.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

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
            startView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            startView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            
            likeCountLabel.leadingAnchor.constraint(equalTo: startView.trailingAnchor, constant: 4),
            likeCountLabel.centerYAnchor.constraint(equalTo: startView.centerYAnchor),
            likeCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6)
        ])
    }
}
