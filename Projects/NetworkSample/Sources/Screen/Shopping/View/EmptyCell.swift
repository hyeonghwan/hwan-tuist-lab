//
//  EmptyCell.swift
//  NetworkSample
//
//  Created by hwan on 7/28/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class EmptyCell: BaseCollectionViewCell, CellIdentifialble {
    
    private let label = UILabel()
    
    override func addChild() {
        self.contentView.addSubview(label)
    }
    
    override func addAttributes() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21, weight: .light)
        label.textColor = .label
        label.textAlignment = .center
        label.text = """
        검색어에 대한 결과가 없습니다.
        """
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
        ])
    }
}
