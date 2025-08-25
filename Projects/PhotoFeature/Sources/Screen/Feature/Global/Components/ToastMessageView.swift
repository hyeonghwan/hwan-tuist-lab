//
//  ToastMessageView.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

typealias ToastStatus = ToastMessageView.ToastStatus

final class ToastMessageView: BaseView {
    private let toastImageView = UIImageView()
    private let toastLabel = UILabel()
    
    enum ToastStatus {
        case check, warning
        var icon: UIImage {
            switch self {
            case .check: return UIImage(systemName: "checkmark")!.withRenderingMode(.alwaysOriginal).withTintColor(.green)
            case .warning: return UIImage(systemName: "exclamationmark.triangle")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemYellow)
            }
        }
    }
    
    override func addAttributes() {
        self.backgroundColor = .lightGray.withAlphaComponent(0.5)
        self.layer.cornerRadius = 20
        toastLabel.font = .systemFont(ofSize: 11, weight: .bold)
        toastLabel.textAlignment = .center
        toastLabel.minimumScaleFactor = 0.5
        toastLabel.numberOfLines = 2
    }
    
    override func addChild() {
        self.addSubview(toastImageView)
        self.addSubview(toastLabel)
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        addLayout()
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            toastImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            toastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            toastImageView.widthAnchor.constraint(equalToConstant: 24),
            toastImageView.heightAnchor.constraint(equalToConstant: 24),
            toastLabel.leadingAnchor.constraint(equalTo: toastImageView.trailingAnchor, constant: 10),
            toastLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            toastLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setData(message: String, status: ToastStatus) {
        toastImageView.image = status.icon
        toastLabel.text = message
    }
}

extension BaseViewController {
    func showToastMessage(width: CGFloat = UIScreen.main.bounds.width - 52,
                          offsetY: CGFloat,
                          status: ToastMessageView.ToastStatus = .warning,
                          message: String = "")
    {
        let toastView = ToastMessageView(
            frame: CGRect(
                x: view.center.x - width / 2,
                y: offsetY,
                width: width,
                height: 44
            )
        )
        
        self.view.addSubview(toastView)
        toastView.setData(message: message, status: status)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.0,
                       options: [.curveEaseIn],
                       animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
}
