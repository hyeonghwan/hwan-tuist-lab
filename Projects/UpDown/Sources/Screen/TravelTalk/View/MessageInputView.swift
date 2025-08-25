//
//  MessageInputView.swift
//  UpDown
//
//  Created by hwan on 7/20/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class MessageInputView: UITextView {
    
    enum FocusState {
        case placeHolder
        case input
    }
    
    private let placeHolderText: String = "메시지를 입력하세요"
    private var maxHeight: CGFloat = 120
    var focusState: FocusState = .placeHolder
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.cornerRadius = 8
        isScrollEnabled = false
        textColor = .placeholderText
        textContainerInset = UIEdgeInsets(top: 18, left: 12, bottom: 18, right: 48)
    }
    
    override var contentSize: CGSize {
        didSet {
            debugPrint("contentSize: \(contentSize)")
        }
    }
    
    override func paste(_ sender: Any?) {
        if focusState == .placeHolder {
            guard let paste = UIPasteboard.general.string, !paste.isEmpty else {
                return
            }
            self.text = ""
            self.textColor = .black
            self.focusState = .input
            self.insertText(paste)
        } else {
            super.paste(sender)
        }
    }
    
    func sizeThatFitViewHeight() -> CGFloat {
        let size = CGSize(
            width: self.frame.width,
            height: .infinity
        )
        let estimatedSize = self.sizeThatFits(size)
        if estimatedSize.height >= maxHeight {
            if !isScrollEnabled { isScrollEnabled = true }
            return maxHeight
        } else {
            if isScrollEnabled { isScrollEnabled = false }
            return estimatedSize.height
        }
    }
    
    func setToFocusIfNeeded(text: String) {
        if self.focusState == .placeHolder && !text.isEmpty {
            self.text = ""
            self.textColor = .black
            self.focusState = .input
        }
    }
    
    func setToPlaceHolderIfNeeded() {
        if self.focusState == .input && text.isEmpty {
            self.focusState = .placeHolder
            self.text = "메시지를 입력하세요"
            self.textColor = .placeholderText
        }
    }
}
