//
//  LottoNumberView.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import HwanKit

final class LottoBallView: BaseView {

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let indicator = UIActivityIndicatorView()

    var number: Int? {
        didSet {
            if number == nil {
                indicator.startAnimating()
                numberLabel.isHidden = true
            } else {
                indicator.stopAnimating()
                numberLabel.isHidden = false
                updateView()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 40)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    override func addChild() {
        translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        addSubview(indicator)
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        clipsToBounds = true
    }
    
    override func addAttributes() {
        indicator.color = .lightGray
    }
    
    private func updateView() {
        guard let number = number else {
            return
        }
        
        if number < 0 {
            numberLabel.text = "+"
            numberLabel.font = .boldSystemFont(ofSize: 20)
            numberLabel.textColor = .black
            backgroundColor = .white
            return
        }
        
        numberLabel.text = "\(number)"
        backgroundColor = color(for: number)
    }

    private func color(for number: Int) -> UIColor {
        switch number {
        case 0:
            return .gray
        case 1...10:
            return .systemYellow
        case 11...20:
            return .systemBlue
        case 21...30:
            return .systemRed
        case 31...40:
            return .systemGray
        case 41...45:
            return .systemGreen
        default:
            return .white
        }
    }
}
