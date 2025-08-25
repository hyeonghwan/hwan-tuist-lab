//
//  BottomLayered.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class BottomLayerTextField: UITextField {
    
    var _btBorderHeight: CGFloat = 4
    var _btBorderColor: CGColor = UIColor.black.cgColor
    private var bottomLayer: CALayer! = nil
    
    private let sizeTraits: [UITrait] = [
        UITraitVerticalSizeClass.self,
        UITraitHorizontalSizeClass.self
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        observeLayout()
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

extension UITextField {
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}
