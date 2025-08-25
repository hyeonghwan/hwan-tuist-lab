//
//  TitleSection.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class TitleSectionHeader: BaseReusableView, CellIdentifialble {
    
    private let label = UILabel()
    
    override func addAttributes() {
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .left
    }
    
    override func addChild() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func set(text: String) {
        self.label.text = text
    }
}
