//
//  ShoppingResultViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import HwanMacros
import Combine

@Logging
final class ShoppingResultViewController: BaseViewController {
    private let headerView = ShoppingHeaderView()
    private let collectionView = ShoppingCollectionView()
    private let refreshControl = UIRefreshControl()
    
    private let scrollAnimator = ScrollAnimator()
    
    
    override func addChild() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
    }
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        self.refreshControl.tintColor = .orange
        
        navigationSetting()
        
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = shoppingDataSource
    }
    
    override func addLayout() {
        scrollAnimator.headerViewTopAnchor = headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        scrollAnimator.headerViewTopAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        view.bringSubviewToFront(headerView)
        
        let headerHeight = headerView.bounds.height
        collectionView.contentInset.top = headerHeight
        collectionView.verticalScrollIndicatorInsets.top = headerHeight
    }
    private func navigationSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = self.view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonDisplayMode = .minimal
    }
}


// MARK: UICollectionViewDelegate
extension ShoppingResultViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollAnimator.showOrHideHeaderAction(scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (windowWidth / 2) - 16,
            height: 270
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: windowWidth, height: 100)
    }
}
extension ShoppingResultViewController {
    @Logging
    fileprivate class ScrollAnimator: NSObject {
        var headerViewTopAnchor: NSLayoutConstraint!
    }
}
