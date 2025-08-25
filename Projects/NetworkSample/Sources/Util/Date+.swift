//
//  Date+.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date { return Date.now.dayBefore }
    static var tomorrow:  Date { return Date.now.dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func dayOfTheWeek() -> String? {
        Resolver.formatter.locale = Locale(identifier:"ko_KR")
        Resolver.formatter.dateFormat = "EEEE"
        return Resolver.formatter.string(from: self)
    }

    func getPreviousSaturday() -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = 7
        return calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: .nextTime,
            direction: .backward
        )
    }

    func findNextSaturday() -> Date? {
        let calendar = Calendar.current
        let components = DateComponents(weekday: 7)
        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime)
    }

}
