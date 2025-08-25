//
//  kinfisher+extensio n.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Kingfisher

@MainActor
extension KingfisherWrapper where Base == KFCrossPlatformImageView {
    
    mutating func downSizingImage(url: URL, size: CGSize) {
        let processor = DownsamplingImageProcessor(
            size: size
        )
        self.indicatorType = .activity
        self.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(0.3)),
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }

    
    mutating func setResizingImage(url: URL, size: CGSize) {
        let processor = ResizingImageProcessor(
            referenceSize: size,
            mode: .aspectFill
        )
        self.indicatorType = .activity
        self.setImage(
            with: url,
            placeholder: nil,
            options: [
                .transition(.fade(0.3)),
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}

