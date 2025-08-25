//
//  ShoppingCollectionViewDataSource.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class ShoppingCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    weak var viewModel: ShoppingObservableViewModel?
    
    init(viewModel: ShoppingObservableViewModel? = nil) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel?.shoppintList.count ?? 0
        if count == 0 {
            return 1
        } else {
            return count
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RefreshFotterView.id, for: indexPath) as! RefreshFotterView
            if let viewModel {
                viewModel.isLoadingPagingIndicator
                    .subscribeAsync { [weak footer] isLoading in
                        if isLoading {
                            footer?.refreshIndicator.startAnimating()
                        } else {
                            footer?.refreshIndicator.stopAnimating()
                        }
                    }
                    .disposed(in: footer.bag)
            }
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let list = viewModel?.shoppintList, list.count >= 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingItemCell.id, for: indexPath) as? ShoppingItemCell else {
                fatalError()
            }
            
            cell.likeButton.controlPublisher(for: .touchUpInside)
                .sinkWeak(on: cell) { cell, button in
                    let origin = button.isSelected
                    button.isSelected = !origin
                }
                .store(in: &cell.subscriptions)
            
            if let list = viewModel?.shoppintList {
                cell.configureCell(with: list[indexPath.row])
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.id, for: indexPath) as? EmptyCell else {
                fatalError()
            }
            return cell
        }
    }
}
