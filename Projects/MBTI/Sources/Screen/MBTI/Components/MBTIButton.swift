//
//  MBTIButton.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

enum MBTIButtonGroup {
    static var eiStack: MBTIStack { MBTIStack(titles: ["E", "I"]) }
    static var snStack: MBTIStack { MBTIStack(titles: ["S", "N"]) }
    static var tfStack: MBTIStack { MBTIStack(titles: ["T", "F"]) }
    static var jpStack: MBTIStack { MBTIStack(titles: ["J", "P"]) }
    
    final class MBTIStack: UIStackView {
        struct State { var selected: Int }

        var selectedObservable = LazyObservable<String>()
        
        private var state: State = .init(selected: -1) {
            didSet {
                selectedObservable.source(.next(self.selectedLetter ?? ""))
            }
        }
        
        private let titles: [String]
        
        var selectedLetter: String? {
            guard
                self.state.selected >= 0,
                let button = self.arrangedSubviews[state.selected] as? UIButton
            else {
                return nil
            }
            
            return button.title(for: .normal)
        }

        override init(frame: CGRect) {
            self.titles = []
            super.init(frame: frame)
        }
        
        required init(coder: NSCoder) { fatalError() }
        
        init(titles: [String]) {
            self.titles = titles
            super.init(frame: .zero)
            axis = .vertical
            spacing = 8

            for (index, title) in titles.enumerated() {
                let button = MBTIButton()
                button.tag = index
                button.setAttribute(title: title)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addAction(UIAction(handler: { [weak self] _ in
                    self?.handleEvent(index)
                }), for: .touchUpInside)
                addArrangedSubview(button)
                NSLayoutConstraint.activate([
                    button.widthAnchor.constraint(equalToConstant: 50),
                    button.heightAnchor.constraint(equalToConstant: 50)
                ])
            }
        }

        private func handleEvent(_ newSelected: Int) {
            let origin = state.selected
            
            if origin == newSelected {
                return
            }
            
            if origin != -1 {
                let button = (arrangedSubviews[origin] as? UIButton)
                button?.isSelected = false
                button?.layer.borderColor = UIColor.lightGray.cgColor
            }
            
            let button = (arrangedSubviews[newSelected] as? UIButton)
            button?.isSelected = true
            button?.layer.borderColor = UIColor.clear.cgColor
            state = .init(selected: newSelected)
        }
    }
    
    final class MBTIButton: BaseButton {
        override func addAttributes() {
            self.setTitleColor(.lightGray, for: .normal)
            self.setTitleColor(.white, for: .selected)
            self.layer.cornerRadius = 25
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.clipsToBounds = true
            setBackgroundColor(.clear, for: .normal)
            setBackgroundColor(.validStateColor, for: .selected)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        }
        func setAttribute(title: String) { self.setTitle(title, for: .normal) }
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let resolvedColor = color.resolvedColor(with: self.traitCollection)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1), format: format)
        
        let image = renderer.image { context in
            resolvedColor.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }.resizableImage(withCapInsets: .zero, resizingMode: .stretch)

        self.setBackgroundImage(image, for: state)
    }
}
