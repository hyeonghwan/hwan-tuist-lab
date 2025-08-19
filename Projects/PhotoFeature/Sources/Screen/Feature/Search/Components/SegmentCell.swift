//
//  SegmentCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class SegmentCell: BaseCollectionViewCell, CellIdentifialble {
    private let segment = UISegmentedControl(items: ["조회", "다운로드"])
    
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
    
    
    func set(items: [String], selectedIndex: Int) {
        
    }
}
