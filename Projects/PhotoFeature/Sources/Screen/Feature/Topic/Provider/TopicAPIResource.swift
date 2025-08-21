//
//  TopicAPIResource.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient


enum Topic: String, CaseIterable {
    case architecture_interior = "architecture-interior"
    case golden_hour = "golden-hour"
    case wallpapers = "wallpapers"
    case nature = "nature"
    case renders_3d = "3d-renders"
    case travel = "travel"
    case textures_patterns = "textures-patterns"
    case street_photography = "street-photography"
    case film = "film"
    case archival = "archival"
    case experimental = "experimental"
    case animals = "animals"
    case fashion_beauty = "fashion-beauty"
    case people = "people"
    case business_work = "business-work"
    case food_drink = "food-drink"
}

struct TopicAPIResource: APIResource {
    typealias ResponseType = [TopicPhotoDTO]
    
    private static var client_id: String = {
        Bundle.main.infoDictionary?["PHOTO_ACCESS_KEY"] as? String ?? ""
    }()
    
    var host: String = "api.unsplash.com"
    var path: String = "/search/photos"
    var method: HTTPMethod = .get
    var headers: [String: String]? = [ "Authorization": "Client-ID \(Self.client_id)" ]
    
    var query: Query?
    
    init(topic: Topic) {
        self.path = "/topics/\(topic.rawValue)/photos"
    }
}
