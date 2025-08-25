//
//  ShoppingCollectionView.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class ShoppingCollectionView: BaseCollectiionView {
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.init(frame: .zero, collectionViewLayout: layout)
        self.alwaysBounceVertical = true
        self.contentInset.left = 8
        self.contentInset.right = 8
        
        self.register(
            ShoppingItemCell.self,
            forCellWithReuseIdentifier: ShoppingItemCell.id
        )
        
        self.register(
            RefreshFotterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RefreshFotterView.id
        )
        
        self.register(
            EmptyCell.self,
            forCellWithReuseIdentifier: EmptyCell.id
        )
    }
}
