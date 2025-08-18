//
//  PhotoStatAPIResource.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient

struct PhotoStatAPIResource: APIResource {
    typealias ResponseType = StatsResponseDTO
    
    private static var client_id: String = {
        Bundle.main.infoDictionary?["PHOTO_ACCESS_KEY"] as? String ?? ""
    }()
    
    var host: String = "api.unsplash.com"
    var path: String
    var method: HTTPMethod = .get
    var headers: [String: String]? = [ "Authorization": "Client-ID \(Self.client_id)" ]
    
    var query: Query?
    
    init(id: String) {
        self.path = "/photos/\(id)/statistics"
    }
}
