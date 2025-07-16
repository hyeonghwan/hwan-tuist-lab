//
//  String+extension.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit


extension String {
    var isNotEmpty: Bool { !isEmpty }
    var space: Self { " " }
    var empty: Self { "" }
    func removeSpace() -> Self {
        self.replacingOccurrences(of: space, with: empty)
    }
    
    func highlightKeyword(
        _ keyword: String,
        foregroundColor: UIColor = .label,
        backgroundColor: UIColor = .systemYellow.withAlphaComponent(0.4)
    ) -> NSAttributedString
    {
        let attributed = NSMutableAttributedString(string: self)

        let nsText = self.lowercased() as NSString
        var searchRange = NSRange(location: 0, length: nsText.length)

        while let foundRange = nsText.range(of: keyword, options: [], range: searchRange).nonEmpty {
            attributed.addAttributes(
                [
                    .foregroundColor: foregroundColor,
                    .backgroundColor: backgroundColor
                ],
                range: foundRange
            )
            let nextLocation: Int = foundRange.location + foundRange.length
            searchRange = NSRange(location: nextLocation, length: nsText.length - nextLocation)
        }
        return attributed
    }
}

private extension NSRange {
    var nonEmpty: NSRange? {
        location != NSNotFound && length > 0 ? self : nil
    }
}

extension NSAttributedString {
    static let separator = NSAttributedString(string: ", ")
}
