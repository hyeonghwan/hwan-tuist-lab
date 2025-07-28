//
//  ShoppingCollectionViewDataSource.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit


final class ShoppingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var viewModel: ShoppingViewModel?
    
    init(viewModel: ShoppingViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.shoppingListSubject.value.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RefreshFotterView.id, for: indexPath) as! RefreshFotterView
            
            if let viewModel {
                viewModel.isLoadingNextPage
                    .sinkWeakStore(on: footer, in: &footer.cancelAable) { footer, isLoading in
                        debugPrint("Footer: \(isLoading)")
                        if isLoading {
                            footer.refreshIndicator.startAnimating()
                        } else {
                            footer.refreshIndicator.stopAnimating()
                        }
                    }
            }
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingItemCell.id, for: indexPath) as? ShoppingItemCell else {
            fatalError()
        }
        
        if let list = viewModel?.shoppingListSubject.value.list {
            cell.configureCell(with: list[indexPath.row])
        }
        
        return cell
    }
}
