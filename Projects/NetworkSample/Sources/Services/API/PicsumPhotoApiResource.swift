//
//  PicsumPhotoApiResource.swift
//  NetworkSample
//
//  Created by hwan on 7/31/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct PicsumPhotoApiResource: APIResource {
    typealias ResponseType = String
    
    var host: String = "picsum.photos"
    
    var path: String = "v2/list"
    
    var method: HTTPMethod = .get
    
    var headers: [String : String]?
    
    var query: Query
    
    struct PicsumQuery: Query {
        var page: Int
    }
}
