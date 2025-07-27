//
//  NaverBookSearchApiResource.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

typealias BookSearchQuery = NaverBookSearchApiResource.BookSearchQuery

struct NaverBookSearchApiResource: APIResource {
    
    struct BookSearchQuery: Query {
        let query: String
        let display: Int
        let start: Int
        let sort: String
    }
    
    typealias ResponseType = BoxOfficeResultDTO

    static var defaultPath: String {
        "v1/search/book.json"
    }
    
    var headers: [String : String]? {
        [
            "X-Naver-Client-Id": "\(client_id)",
            "X-Naver-Client-Secret": "\(client_secret)"
        ]
    }
    
    var method: HTTPMethod = .get
    var query: any Query
    let scheme = "https"
    let host: String = "openapi.naver.com"
    var path: String
    
    init(method: HTTPMethod = .get, query: any Query, path: String = "") {
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
