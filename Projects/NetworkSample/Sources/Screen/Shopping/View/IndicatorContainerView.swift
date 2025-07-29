//
//  IndicatorContainerView.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class IndicatorContainerView: BaseView {
    private(set) var indicator = UIActivityIndicatorView()
    
    override func addChild() {
        self.addSubview(indicator)
    }
    
    override func addAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.color = .green
        
        addLayout()
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
