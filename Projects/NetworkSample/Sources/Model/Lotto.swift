//
//  Lotto.swift
//  NetworkSample
//
//  Created by hwan on 7/23/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct LottoResult: Codable {
    let drawNo: Int
    let numbers: [Int]
    let bonusNo: Int
    let date: String
    let divisions: [Division]
    let totalSalesAmount: Int
    let winnersCombination: WinnersCombination

    enum CodingKeys: String, CodingKey {
        case drawNo = "draw_no"
        case numbers
        case bonusNo = "bonus_no"
        case date
        case divisions
        case totalSalesAmount = "total_sales_amount"
        case winnersCombination = "winners_combination"
    }
}

struct Division: Codable {
    let prize: Int?
    let winners: Int?
}

struct WinnersCombination: Codable {
    let auto: Int?
    let manual: Int?
}
