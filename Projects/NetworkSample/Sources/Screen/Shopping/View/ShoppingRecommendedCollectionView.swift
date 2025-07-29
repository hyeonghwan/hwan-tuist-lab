//
//  ShoppingHorizontalCollectionView.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class ShoppingRecommendedCollectionView: BaseCollectiionView {
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 150)
        self.init(frame: .zero, collectionViewLayout: layout)
        self.alwaysBounceHorizontal = true
        self.contentInset.left = 8
        self.contentInset.right = 8
    }
    
    override func addAttributes() {
        self.register(
            RecomendedCell.self,
            forCellWithReuseIdentifier: RecomendedCell.id
        )
    }
}
