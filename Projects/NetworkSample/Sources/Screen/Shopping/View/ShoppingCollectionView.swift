//
//  ShoppingCollectionView.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit


final class ShoppingCollectionView: UICollectionView {
    
    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
    }
}
