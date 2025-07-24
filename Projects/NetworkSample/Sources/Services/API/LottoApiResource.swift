//
//  LottoApiResource.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


struct LottoApiResource: APIResource {
    typealias ResponseType = LottoDTO
    
    var API_KEY: String { "" }
    
    var method: HTTPMethod = .get
    
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
