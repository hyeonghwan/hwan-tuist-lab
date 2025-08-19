//
//  SearchEmptyCell.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class SearchInfoCell: BaseCollectionViewCell, CellIdentifialble {
    private let label = UILabel()
    
    enum Mode {
        case info
        case empty
        
        var string: String {
            switch self {
            case .info:
                return "사진을 검색해보세요."
            case .empty:
                return "검색 결과가 없어요."
            }
        }
    }
    
    override func addAttributes() {
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
    }
    
    override func addChild() {
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func setText(mode: Mode) {
        self.label.text = mode.string
    }
}
