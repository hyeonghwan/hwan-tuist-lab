//
//  BottomLayeredTextField.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class BottomLayerTextField: UITextField {
    var _btBorderHeight: CGFloat = 4
    var _btBorderColor: CGColor = UIColor.label.withAlphaComponent(0.6).cgColor
    private var bottomLayer: CALayer! = nil
    
    private let sizeTraits: [UITrait] = [
        UITraitVerticalSizeClass.self,
        UITraitHorizontalSizeClass.self
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeLayout()
        self.attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력해주세요:)",
            attributes: [
                .foregroundColor : UIColor.lightGray.withAlphaComponent(0.5),
                .font : UIFont.systemFont(ofSize: 13)
            ]
        )
        self.font = .systemFont(ofSize: 13)
        self.textColor = .label
        self._btBorderHeight = 1
        self._btBorderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        observeLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bottomLayer == nil {
            bottomLayer = CAShapeLayer()
            bottomLayer.frame = CGRect(
                x: -8,
                y: self.bounds.height - _btBorderHeight,
                width: self.bounds.width + 8,
                height: _btBorderHeight
            )
            bottomLayer.backgroundColor = _btBorderColor
            self.layer.addSublayer(bottomLayer)
        }
    }
    
    private func observeLayout() {
        registerForTraitChanges(sizeTraits) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.bottomLayer.removeFromSuperlayer()
            self.bottomLayer = nil
            self.setNeedsLayout()
        }
    }
}

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}

