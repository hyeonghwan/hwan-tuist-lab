//
//  PhotoSelectView.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class PhotoSelectView: BaseView {
    enum Constants {
        static let spacing: CGFloat = 4
    }
    
    var borderWidth: CGFloat = 3
    
    convenience init(isCameraAppear: Bool = false, radius: CGFloat = 50) {
        self.init(frame: .zero)
        if isCameraAppear {
            let camera = UIImageView()
            let config = UIImage.SymbolConfiguration(paletteColors: [.white, .validStateColor])
            camera.image = UIImage(systemName: "camera.circle.fill")?.applyingSymbolConfiguration(config)
            camera.contentMode = .scaleAspectFit
            camera.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(camera)
            self.bringSubviewToFront(camera)
            NSLayoutConstraint.activate([
                camera.widthAnchor.constraint(equalToConstant: 36),
                camera.heightAnchor.constraint(equalToConstant: 36),
                camera.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                camera.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        self.imageView.layer.borderWidth = borderWidth
        self.imageView.layer.borderColor = UIColor.validStateColor.cgColor
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2
    }
    
    override func addChild() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addLayout()
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.spacing),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.spacing),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.spacing),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.spacing)
        ])
    }
    
    func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
