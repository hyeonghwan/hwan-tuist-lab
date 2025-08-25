//
//  DayValue.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct DayValue: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let value: Double
}
