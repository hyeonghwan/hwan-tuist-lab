//
//  PinterestPhotoCollectionView.swift
//  PhotoFeature
//
//  Created by hwan on 8/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class PinterestPhotoCollectionView: BaseCollectiionView {
    
    override func addAttributes() {
        self.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.id
        )
        self.register(
            RefreshFotterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RefreshFotterView.id
        )
    }
}
