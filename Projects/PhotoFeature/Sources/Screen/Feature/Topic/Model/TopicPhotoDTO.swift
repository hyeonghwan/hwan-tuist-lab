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

extension TopicPhotoDTO {
    func toModel() -> TopicPhotoModel {
        TopicPhotoModel(
            id: self.id,
            createdAt: self.createdAt ?? Date.now.toFormatted(),
            width: self.width ?? 0,
            height: self.height ?? 0,
            urls: self.urls ?? .init(raw: nil, full: nil, regular: nil, small: nil, thumb: nil, smallS3: nil),
            likes: self.likes ?? 0,
            user: self.user ?? .init(id: nil, updatedAt: nil, username: nil, name: nil, firstName: nil, lastName: nil, twitterUsername: nil, portfolioURL: nil, bio: nil, location: nil, links: nil, profileImage: nil)
        )
    }
}


struct TopicPhotoModel: Codable, Hashable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let urls: UrlsDTO
    let likes: Int
    let user: UserDTO
    
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
