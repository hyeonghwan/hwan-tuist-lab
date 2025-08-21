//
//  UserFavorite.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

final class FavoriteModel {
    let model: PhotoModel
    init(model: PhotoModel) {
        self.model = model
    }
}

final class UserFavoriteCache {
    private(set) var cache = NSCache<NSString, FavoriteModel>()
    
    static let shared = UserFavoriteCache()
    
    private init() { }
    
    func set(_ model: PhotoModel) {
        cache.setObject(FavoriteModel(model: model), forKey: model.id as NSString)
    }
    
    func isFavorite(id: String) -> Bool {
        if let model = cache.object(forKey: id as NSString) {
            return true
        } else {
            return false
        }
    }
    
    func remove(id: String) {
        cache.removeObject(forKey: id as NSString)
    }
    
    func removeAll() {
        cache.removeAllObjects()
    }
}
