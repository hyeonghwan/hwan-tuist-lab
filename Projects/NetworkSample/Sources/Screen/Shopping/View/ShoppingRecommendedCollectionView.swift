//
//  ShoppingHorizontalCollectionView.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import Combine

typealias RecommendedDataSource = ShoppingRecommendedCollectionView.RecommendedDataSource
typealias RecommendedDelegate = ShoppingRecommendedCollectionView.RecommendedDelegate

final class ShoppingRecommendedCollectionView: BaseCollectiionView {
    
    final class RecommendedDataSource: NSObject, UICollectionViewDataSource {
        private var cancelAble: AnyCancellable?
        private(set) var recommendedViewModel = CurrentValueSubject<[String], Never>([])
        private var modelCount: Int { recommendedViewModel.value.count }
        private var models: [String] { recommendedViewModel.value }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { modelCount }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomendedCell.id, for: indexPath) as! RecomendedCell
            cell.configureCell(with: models[indexPath.row])
            return cell
        }
    }

    final class RecommendedDelegate: NSObject, UICollectionViewDelegateFlowLayout {
        var cellWidth: CGFloat { 120 }
        var cellHeight: CGFloat { 120 }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: cellWidth, height: cellHeight)
        }
    }

    convenience init(delegate: RecommendedDelegate, dataSource: RecommendedDataSource) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: layout)
        self.alwaysBounceHorizontal = true
        self.contentInset.left = 8
        self.contentInset.right = 8
        self.dataSource = dataSource
        self.delegate = delegate
        
    }
    
    override func addAttributes() {
        self.register(
            RecomendedCell.self,
            forCellWithReuseIdentifier: RecomendedCell.id
        )
    }
}
