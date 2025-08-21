//
//  FilterButton.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Design
import UIKit

final class FilterButton: BaseButton {
    
    enum SortType: String {
        case relevant
        case latest
        
        var title: String {
            switch self {
            case .relevant: return "관련순"
            case .latest:  return "최신순"
            }
        }
        var image: UIImage? {
            switch self {
            case .relevant: return UIImage(systemName: "text.badge.checkmark")?.withTintColor(.black)
            case .latest:  return UIImage(systemName: "clock")?.withTintColor(.black)
            }
        }
    }
    
    private(set) var currentType: SortType = .relevant {
        didSet {
            updateType()
        }
    }
    
    override func addAttributes() {
        self.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        self.configuration = .plain()
        self.backgroundColor = .lightGray.withAlphaComponent(0.3)
        self.layer.cornerRadius = 12
        self.tintColor = .black
        updateType()
    }
    
    @objc
    private func toggle() {
        currentType = (currentType == .relevant) ? .latest : .relevant
        self.sendActions(for: .valueChanged)
    }
    
    private func updateType() {
        self.setAttributedTitle(
            NSAttributedString(
                string: currentType.title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 11, weight: .semibold),
                    .foregroundColor : UIColor.label
                ]),
            for: .normal
        )
        
        self.setImage(currentType.image, for: .normal)
        self.configuration?.imagePadding = 6
        
        imageView?.contentMode = .scaleAspectFit
        configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
    }
}
