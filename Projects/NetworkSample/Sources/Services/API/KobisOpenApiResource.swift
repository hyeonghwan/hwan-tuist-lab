//
//  Resources.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct KobisOpenApiResource: APIResource {
    typealias ResponseType = BoxOfficeResultDTO
    var method: HTTPMethod = .get
    let scheme = "https"
    let host: String = "kobis.or.kr"
    let path: String = "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    var API_KEY: String {
        Bundle.main.infoDictionary?["MOVIE_API_KEY"] as? String ?? ""
    }
}
