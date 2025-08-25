//
//  SegmentCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import CustomObservable

final class SegmentCell: BaseCollectionViewCell, CellIdentifialble {
    private(set) var segment = UISegmentedControl(items: [SegmentItem.viewer.rawValue, SegmentItem.download.rawValue])
    
    override func addAttributes() {
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addChild() {
        contentView.addSubview(segment)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            segment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segment.topAnchor.constraint(equalTo: contentView.topAnchor),
            segment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
