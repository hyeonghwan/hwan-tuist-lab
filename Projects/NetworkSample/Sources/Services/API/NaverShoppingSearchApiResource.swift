//
//  NaverShoppingSearchApiResource.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

typealias ShoppingSearchQuery = NaverShoppingSearchApiResource.ShoppingSearchQuery
typealias ShoppingSortType = NaverShoppingSearchApiResource.SortType
typealias ShoppingItemResultDTO = NaverAPIResponse<NaverSearchResultDTO<ShoppingItemDTO>>

struct NaverShoppingSearchApiResource: APIResource {
    
    enum SortType: String {
        case sim
        case date
        case asc
        case dsc
        case none
        
        var string: String {
            self.rawValue
        }
        
        var filterString: String {
            switch self {
            case .sim:
                "정확도"
            case .date:
                "닐짜순"
            case .asc:
                "가격높은순"
            case .dsc:
                "가격낮은순"
            case .none:
                ""
            }
        }
        
        static func matchTag(_ tag: Int) -> SortType {
            return switch tag {
            case 0: SortType.sim
            case 1: SortType.date
            case 2: SortType.asc
            case 3: SortType.dsc
            default: SortType.sim
            }
        }
    }
    
    struct ShoppingSearchQuery: Query {
        let query: String
        let display: Int
        let start: Int
        let sort: String
    }
    
    typealias ResponseType = ShoppingItemDTO

    static var defaultPath: String {
        "v1/search/shop.json"
    }
    
    var headers: [String : String]? {
        [
            "X-Naver-Client-Id": "\(client_id)",
            "X-Naver-Client-Secret": "\(client_secret)",
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    var method: HTTPMethod = .get
    var query: Query
    let scheme = "https"
    let host: String = "openapi.naver.com"
    var path: String
    
    init(method: HTTPMethod = .get, query: Query, path: String = "") {
        self.method = method
        self.query = query
        self.path = "/" + Self.defaultPath
        if !path.isEmpty {
            self.path = "\(self.path)/\(path)"
        }
    }
    
    private var client_id: String { Bundle.main.infoDictionary?["NAVER_CLIENT_ID"] as? String ?? "" }
    private var client_secret: String { Bundle.main.infoDictionary?["NAVER_CLIENT_SECRET"] as? String ?? "" }
}
