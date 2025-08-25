//
//  Layout.swift
//  UpDown
//
//  Created by hwan on 7/20/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class BottomAlignedFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        // super.prepare() -> does nothing
        guard let collectionView else { return }
        guard collectionView.numberOfSections > 0, collectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        
        let contentHeight = collectionViewContentSize.height
        let viewHeight = collectionView.bounds.height
        let visibleHeight = viewHeight - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom
        
        if contentHeight > visibleHeight {
            let offset = contentHeight - visibleHeight - collectionView.adjustedContentInset.top
            let targetOffset = CGPoint(x: 0, y: offset)
            collectionView.setContentOffset(targetOffset, animated: false)
        }
    }
}
