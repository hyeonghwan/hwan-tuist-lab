//
//  String+.swift
//  NetworkSample
//
//  Created by hwan on 7/27/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

extension String {
    func htmlStringToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        do {
            let attr = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            let mutable = NSMutableAttributedString(string: attr.string)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.lineBreakStrategy = .hangulWordPriority
            
            mutable.addAttributes(
                [
                    .font: UIFont.systemFont(ofSize: 13, weight: .light),
                    .foregroundColor: UIColor.label,
                    .paragraphStyle: paragraphStyle
                ],
                range: NSRange(location: 0, length: mutable.length)
            )
            
            return mutable
            
        } catch {
            print(error)
        }
        return nil
    }
}
