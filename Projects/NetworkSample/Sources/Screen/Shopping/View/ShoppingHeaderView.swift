//
//  ShoppingHeaderView.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class ShoppingHeaderView: BaseView {
    
    private(set) var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGreen
        label.text = "0 개의 검색 결과"
        label.textAlignment = .left
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let sortByacurrate = BoxButton(title: ShoppingSortType.sim.filterString).buildViewTag(0)
    private let sortByDate = BoxButton(title: ShoppingSortType.date.filterString).buildViewTag(1)
    private let sortByHighCost = BoxButton(title: ShoppingSortType.dsc.filterString).buildViewTag(2)
    private let sortByLowCost = BoxButton(title: ShoppingSortType.asc.filterString).buildViewTag(3)
    
     var buttonList: [Int: BoxButton] {
        [
            sortByacurrate.tag: sortByacurrate,
            sortByDate.tag: sortByDate,
            sortByHighCost.tag: sortByHighCost,
            sortByLowCost.tag: sortByLowCost
        ]
    }
    
    var selectedIndex = -1 {
        didSet {
            assert(self.selectedIndex >= 0)
            if oldValue == self.selectedIndex {
                return
            }
            
            if let oldSelectedButton = buttonList[oldValue] {
                oldSelectedButton.isSelected = false
            }
            
            if let newSelectedButton = buttonList[self.selectedIndex] {
                newSelectedButton.isSelected = true
            }
        }
    }
    
    override func addChild() {
        self.backgroundColor = .systemBackground
        self.addSubview(label)
        self.addSubview(horizontalStackView)
        label.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonList.sorted(by: { $0.key < $1.key }).forEach { item in
            let button = item.value
            button.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.addArrangedSubview(button)
            button.addAction(
                UIAction(
                    handler: { [weak self, weak button] _ in
                        self?.selectedIndex = button?.tag ?? 0
                    }
                ),
                for: .touchUpInside
            )
        }
    }
    
    override func addAttributes() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            horizontalStackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            horizontalStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
        selectedIndex = 0
    }
}

#Preview(traits: .fixedLayout(
    width: UIScreen.main.bounds.width,
    height: UIScreen.main.bounds.height)
) {
    let view = UIView()
    
    let header = ShoppingHeaderView()
    view.translatesAutoresizingMaskIntoConstraints = false
    header.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(header)
    header.layer.borderColor = UIColor.blue.cgColor
    header.layer.borderWidth = 3
    view.layer.borderColor = UIColor.red.cgColor
    view.layer.borderWidth = 4
    let height = header.heightAnchor.constraint(equalToConstant: 50)
    height.isActive = true
    height.priority = .defaultLow
    
    NSLayoutConstraint.activate([
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
        header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
    ])
    
    return view
}
