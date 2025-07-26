//
//  Formatter.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

enum NumberResolver {
    static let numberFormatter = NumberFormatter()
}

extension Numeric {
    func formattedNumber() -> String? {
        NumberResolver.numberFormatter.numberStyle = .decimal
        guard let nsNumber = self as? NSNumber,
              let formatted = NumberResolver.numberFormatter.string(from: nsNumber) else {
            return nil
        }
        return formatted
    }
}
