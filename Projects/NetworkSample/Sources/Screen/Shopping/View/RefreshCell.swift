//
//  RefreshCell.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class RefreshFotterView: UICollectionReusableView, CellIdentifialble {
    
    private(set) var refreshIndicator = UIActivityIndicatorView()
    
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
        refreshIndicator.color = .orange
        refreshIndicator.style = .large
        refreshIndicator.translatesAutoresizingMaskIntoConstraints = false
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
