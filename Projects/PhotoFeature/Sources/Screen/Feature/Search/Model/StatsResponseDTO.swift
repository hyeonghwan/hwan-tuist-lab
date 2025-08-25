//
//  PhotoStatics.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct StatsResponseDTO: Codable {
    let id: String?
    let downloads: MetricDTO?
    let views: MetricDTO?
    let likes: MetricDTO?
}

struct MetricDTO: Codable {
    let total: Int?
    let historical: HistoricalDTO?
}

struct HistoricalDTO: Codable {
    let change: Int?
    let resolution: String?
    let quantity: Int?
    let values: [HistoricalValueDTO]?
}

struct HistoricalValueDTO: Codable, Hashable {
    let date: String?
    let value: Int?
}
