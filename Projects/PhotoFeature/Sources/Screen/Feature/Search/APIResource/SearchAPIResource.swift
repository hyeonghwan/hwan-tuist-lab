//
//  SearchApiResource.swift
//  PhotoFeature
//
//  Created by hwan on 8/16/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient

struct SearchQuery: Query {
    var page: Int
    var query: String
    var per_page: Int
    var order_by: String? // latest, relevant
    var color: String? // Filter results by color. Optional. Valid values are:
}


struct SearchAPIResource: APIResource {
    typealias ResponseType = SearchResponseDTO
    
    private static var client_id: String = {
        Bundle.main.infoDictionary?["PHOTO_ACCESS_KEY"] as? String ?? ""
    }()
    
    var host: String = "api.unsplash.com"
    var path: String = "/search/photos"
    var method: HTTPMethod = .get
    var headers: [String: String]? = [ "Authorization": "Client-ID \(Self.client_id)" ]
    
    var query: Query?
    
    init(query: SearchQuery) {
        self.query = query
    }
}
