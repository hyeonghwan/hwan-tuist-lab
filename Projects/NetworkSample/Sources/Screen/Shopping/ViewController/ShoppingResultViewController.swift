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


extension ShoppingResultViewController {
    @Logging
    fileprivate class ScrollAnimator: NSObject {
        var headerViewTopAnchor: NSLayoutConstraint!
    }
}
