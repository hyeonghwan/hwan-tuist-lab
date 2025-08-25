//
//  SectionDateHeaderView.swift
//  UpDown
//
//  Created by hwan on 7/21/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class SectionDateHeaderView: UICollectionReusableView, CellIdentifialble {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func addLayout() {
        self.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateLabel.text = dateFormatter.string(from: date)
    }
}
