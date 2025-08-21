//
//  SearchResponse.swift
//  PhotoFeature
//
//  Created by hwan on 8/16/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct SearchResponseDTO: Codable {
    let total: Int
    let totalPages: Int
    let results: [PhotoDTO]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct PhotoDTO: Codable {
    let id: String
    let slug: String?
    let alternativeSlugs: [String: String]?
    let createdAt: String?
    let updatedAt: String?
    let promotedAt: String??
    let width: Int?
    let height: Int?
    let color: String?
    let blurHash: String?
    let description: String??
    let altDescription: String??
    let breadcrumbs: [String]?
    let urls: UrlsDTO?
    let links: LinksDTO?
    let likes: Int?
    let user: UserDTO?

    enum CodingKeys: String, CodingKey {
        case id, slug
        case alternativeSlugs = "alternative_slugs"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt = "promoted_at"
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case breadcrumbs
        case urls
        case links
        case likes
        case user
    }
}

import UIKit
extension PhotoDTO {
    func toModel() -> PhotoModel {
        let ratio = CGFloat(self.height ?? 300) / CGFloat(self.width ?? 300)
        return PhotoModel(
            id: self.id,
            regularURL: self.urls?.small ?? "",
            likes: self.likes ?? 0,
            width: self.width ?? 300,
            height: self.height ?? 300,
            ratio: ratio,
            userDTO: self.user,
            userLike: UserFavoriteCache.shared.isFavorite(id: self.id),
            createdAt: self.createdAt?.isoStringToFormattedString()
        )
    }
}

struct UrlsDTO: Hashable, Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
        case smallS3 = "small_s3"
    }
}

struct LinksDTO: Codable {
    let selfLink: String?
    let html: String?
    let download: String?
    let downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

struct TopicSubmissionDTO: Hashable, Codable {
    let status: String?
    let approvedOn: String?

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn = "approved_on"
    }
}

struct UserDTO: Hashable, Codable {
    let id: String?
    let updatedAt: String?
    let username: String?
    let name: String?
    let firstName: String?
    let lastName: String?
    let twitterUsername: String?
    let portfolioURL: String?
    let bio: String?
    let location: String?
    let links: UserLinksDTO?
    let profileImage: ProfileImageDTO?

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case bio, location, links
        case profileImage = "profile_image"
    }
}

struct UserLinksDTO: Hashable, Codable {
    let selfLink: String?
    let html: String?
    let photos: String?
    let likes: String?
    let portfolio: String?
    let following: String?
    let followers: String?

    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case html, photos, likes, portfolio, following, followers
    }
}

struct ProfileImageDTO: Hashable, Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct SocialDTO: Hashable, Codable {
    let instagramUsername: String?
    let portfolioURL: String?
    let twitterUsername: String?
    let paypalEmail: String?

    enum CodingKeys: String, CodingKey {
        case instagramUsername = "instagram_username"
        case portfolioURL = "portfolio_url"
        case twitterUsername = "twitter_username"
        case paypalEmail = "paypal_email"
    }
}
