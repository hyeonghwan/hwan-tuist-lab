//
//  Indicator.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

private class IndicatorContainerView: BaseView {
    private(set) var indicator = UIActivityIndicatorView()
    
    override func addChild() {
        self.addSubview(indicator)
    }
    
    override func addAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.color = .label
        
        addLayout()
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}


final class LoadingIndicator {
    static let shared = LoadingIndicator()
    private var container = IndicatorContainerView()
    private var isShowing = false
    private init() {}
    
    func show() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
            guard let window else { return }
            
            self.container.frame = window.bounds
            
            if self.container.superview == nil {
                window.addSubview(self.container)
            }
            
            self.isShowing = true
            
            self.container.indicator.startAnimating()
            self.container.alpha = 0
            
            UIView.animate(withDuration: 0.1) {
                self.container.alpha = 1
            }
        }
    }
    
    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self, self.isShowing else { return }
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.container.alpha = 0
                }) { _ in
                    self.container.indicator.stopAnimating()
                    if self.container.superview != nil {
                        self.container.removeFromSuperview()
                    }
                    self.isShowing = false
                }
        }
    }
}
