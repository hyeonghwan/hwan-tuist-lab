//
//  SectionDateHeaderView.swift
//  UpDown
//
//  Created by hwan on 7/21/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class SectionDateHeaderView: UICollectionReusableView, CellIdentifialble {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayout()
        addAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addLayout() {
        addSubview(container)
        container.addSubview(dateLabel)
        
        let widthAnchor = container.widthAnchor.constraint(equalToConstant: 100)
        widthAnchor.isActive = true
        widthAnchor.priority = .defaultLow
        
        let heightAnchor = container.heightAnchor.constraint(equalToConstant: 100)
        heightAnchor.isActive = true
        heightAnchor.priority = .defaultLow
        
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            dateLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
    }
    
    private func addAttributes() {
        container.backgroundColor = .black
        dateLabel.textColor = .white
        container.layer.cornerRadius = 12
    }
    
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func setFont(_ font: UIFont) {
        self.dateLabel.font = font
    }
}
