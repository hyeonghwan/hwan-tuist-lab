//
//  DateFormatter.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


fileprivate enum DateResolver {
    static let formatter = DateFormatter()
}

extension Date {
    func toFormat(_ format: String = "yyyy년 MM월 dd일") -> String {
        let formatter = DateResolver.formatter
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func toFormatted() -> Self {
        self.toDate()?.toFormat() ?? Date.now.toFormat()
    }
    
    func toDate(_ format: String = "yyMMdd") -> Date? {
        let formatter = DateResolver.formatter
        formatter.dateFormat = format
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.date(from: self)
    }
}

