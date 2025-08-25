//
//  Coin.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct CoinDTO: Codable {
    var market: String
    var krName: String
    var enName: String
    var event: MarketEventDTO
    
    enum CodingKeys: String, CodingKey {
        case market = "market"
        case krName
        case enName
        case event
    }
}

struct MarketEventDTO: Codable {
    var warning: Bool
    var caution: CautionDTO
}

struct CautionDTO: Codable {
    var PRICE_FLUCTUATIONS: Bool
    var TRADING_VOLUME_SOARING: Bool
    var DEPOSIT_AMOUNT_SOARING: Bool
    var GLOBAL_PRICE_DIFFERENCES: Bool
    var CONCENTRATION_OF_SMALL_ACCOUNTS: Bool
}
