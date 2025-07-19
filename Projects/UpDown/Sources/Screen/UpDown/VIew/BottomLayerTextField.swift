//
//  LayeredTextField.swift
//  UpDown
//
//  Created by hwan on 7/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

@IBDesignable
final class BottomLayerTextField: UITextField {
    
    private var _btBorderHeight: CGFloat = 1
    private var _btBorderColor: CGColor = UIColor.black.cgColor
    private var bottomLayer: CALayer! = nil
    
    private let sizeTraits: [UITrait] = [
        UITraitVerticalSizeClass.self,
        UITraitHorizontalSizeClass.self
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeLayout()
        self.keyboardType = .numberPad
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
                x: 0.0,
                y: self.bounds.height - _btBorderHeight,
                width: self.bounds.width,
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

