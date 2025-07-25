//
//  LottoApiResource.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

typealias LottoQuery = LottoApiResource.LottoQuery

struct LottoApiResource: APIResource {
    typealias ResponseType = LottoDTO
    
    
    struct LottoQuery: Query {
        let method: String
        let drwNo: String
    }
    
    var method: HTTPMethod = .get
    var query: any Query
    var scheme: String {
        "https"
    }
    var host: String {
        "dhlottery.co.kr"
    }
    var path: String {
        "/common.do"
    }
}
