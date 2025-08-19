//
//  Model.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct TopicPhotoDTO: Codable {
    let id: String
    let createdAt: String?
    let width: Int?
    let height: Int?
    let urls: UrlsDTO?
    let likes: Int?
    let user: UserDTO?
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
        case likes
        case user
        case createdAt = "created_at"
    }
}


struct ProfileImage: Codable {
    let medium: String?
}
