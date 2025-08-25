//
//  Resources.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

typealias MovieQuery = KobisOpenApiResource.MovieQuery

struct KobisOpenApiResource: APIResource {
    typealias ResponseType = BoxOfficeResultDTO
    
    struct MovieQuery: Query {
        let targetDt: String
        let API_KEY: String
    }
    
    static var defaultPath: String {
        "kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    }
    
    var method: HTTPMethod = .get
    var query: any Query
    let scheme = "https"
    let host: String = "kobis.or.kr"
    let path: String
    
    init(method: HTTPMethod = .get, query: any Query, path: String = "") {
        self.method = method
        self.query = query
        self.path = "/" + Self.defaultPath + "/" + path
    }
    
    static var API_KEY: String {
        Bundle.main.infoDictionary?["MOVIE_API_KEY"] as? String ?? ""
    }
}
