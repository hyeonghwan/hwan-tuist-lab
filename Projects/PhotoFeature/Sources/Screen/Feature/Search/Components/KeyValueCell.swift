//
//  KeyValueCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class KeyValueCell: BaseCollectionViewCell, CellIdentifialble {
    private let keyLabel = UILabel()
    private let valueLabel = UILabel()
    
    override func addAttributes() {
        keyLabel.font = .preferredFont(forTextStyle: .subheadline)
        keyLabel.textColor = .label
        
        valueLabel.font = .preferredFont(forTextStyle: .subheadline)
        valueLabel.textColor = .secondaryLabel
        valueLabel.textAlignment = .right
    }
    
    override func addChild() {
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        keyLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            keyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            keyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: keyLabel.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: keyLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func set(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}
