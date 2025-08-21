//
//  RefreshFooterView.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import CustomObservable

final class RefreshFotterView: UICollectionReusableView, CellIdentifialble {
    
    private(set) var refreshIndicator = UIActivityIndicatorView()
    private(set) var bag = Bag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAttributes()
        addChild()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addAttributes() {
        refreshIndicator.color = .label
        refreshIndicator.style = .large
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = Bag()
    }
    
    private func addChild() {
        self.addSubview(refreshIndicator)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            refreshIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            refreshIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            refreshIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            refreshIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

