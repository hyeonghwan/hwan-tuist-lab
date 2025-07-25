//
//  Date+.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
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
}
