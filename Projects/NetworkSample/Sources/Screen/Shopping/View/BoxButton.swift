//
//  BoxButton.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class BoxButton: UIButton {
    
    private var buttonTitle: String = ""
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.buttonTitle = title
        addAtributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.configuration = selectedConfiguration
            } else {
                self.configuration = nonSelectedConfiguration
            }
        }
    }
    
    func buildViewTag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    private var nonSelectedConfiguration: UIButton.Configuration? {
        var configuration = self.configuration
        configuration?.baseBackgroundColor = .clear
        configuration?.baseForegroundColor = .label
        configuration?.background.strokeColor = .label
        configuration?.titleAlignment = .center
        return configuration
    }
    
    private var selectedConfiguration: UIButton.Configuration? {
        var configuration = self.configuration
        configuration?.baseBackgroundColor = dynamicBackgroundColor
        configuration?.baseForegroundColor = dynamicColor
        return configuration
    }
    
    private let dynamicBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .white
        } else {
            return .black
        }
    }
    
    private let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        if traitCollection.userInterfaceStyle == .dark {
            return .black
        } else {
            return .white
        }
    }
    
    private func addAtributes() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .label
        configuration.titlePadding = 0
        configuration.buttonSize = .medium
        configuration.background.strokeColor = .label
        configuration.titleAlignment = .center
        
        var attributedStirng = AttributedString("\(buttonTitle)")
        attributedStirng.setAttributes(AttributeContainer([
            .font : UIFont.boldSystemFont(ofSize: 14)])
        )
        configuration.attributedTitle = attributedStirng
        self.configuration = configuration
    }
}


#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    let view = UIView()
    view.backgroundColor = .clear
    let button = BoxButton(title: "정확도")
    
    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    return view
}
