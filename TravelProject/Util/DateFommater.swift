//
//  DateFommater.swift
//  TravelProject
//
//  Created by hwan on 7/13/25.
//

import Foundation


fileprivate enum DateResolver {
    static let formatter = DateFormatter()
}

extension Date {
    func toFormat() -> String {
        let formatter = DateResolver.formatter
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}

extension String {
    func toFormatted() -> Self {
        self.toDate()?.toFormat() ?? Date.now.toFormat()
    }
    
    func toDate() -> Date? {
        let formatter = DateResolver.formatter
        formatter.dateFormat = "yyMMdd"
        formatter.locale = Locale(identifier:"ko_KR")
        return formatter.date(from: self)
    }
}
