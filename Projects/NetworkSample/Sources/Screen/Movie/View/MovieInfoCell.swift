//
//  MovieInfoCell.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class MovieInfoCell: UITableViewCell, CellIdentifialble {
    
    private var container = AttributeContainer()
    
    private lazy var numberButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .fixed
        button.configuration = configuration
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        container.font = .systemFont(ofSize: 13, weight: .bold)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(boxOffice: DailyBoxOfficeDTO, index: Int) {
        guard var config = numberButton.configuration else { return }
        config.attributedTitle = AttributedString("\(index)", attributes: container)
        numberButton.configuration = config
        
        label.text = boxOffice.movieNm
        dateLabel.text = boxOffice.openDt
    }
    
    private func addLayout() {
        contentView.addSubview(numberButton)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        
        numberButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numberButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            numberButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            numberButton.widthAnchor.constraint(equalToConstant: 44),
            numberButton.heightAnchor.constraint(equalToConstant: 30),
            
            label.centerYAnchor.constraint(equalTo: numberButton.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: numberButton.trailingAnchor, constant: 16),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            dateLabel.centerYAnchor.constraint(equalTo: numberButton.centerYAnchor)
        ])
    }
}
