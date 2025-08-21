//
//  Date.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

enum Resolver {
    static let formatter = DateFormatter()
    static let isoFormatter = ISO8601DateFormatter()
}

extension String {
    func isoStringtoDate() -> Date? {
        let isoFormatter = Resolver.isoFormatter
        if let date = isoFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func isoStringToFormattedString() -> String {
        (self.isoStringtoDate() ?? Date.now).toFormatted()
    }
}

extension Date {
    func toFormatted(_ format: String = "yyyy년 MM월 dd일") -> String {
        let formatter = Resolver.formatter
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
