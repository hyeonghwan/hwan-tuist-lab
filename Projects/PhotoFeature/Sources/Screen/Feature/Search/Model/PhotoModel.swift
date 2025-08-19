//
//  PhotoModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

struct PhotoModel: Hashable {
    let id: String
    let regularURL: String
    let likes: Int
    let width: Int
    let height: Int
    let ratio: CGFloat
    let userDTO: UserDTO?
    let createdAt: String?
}
