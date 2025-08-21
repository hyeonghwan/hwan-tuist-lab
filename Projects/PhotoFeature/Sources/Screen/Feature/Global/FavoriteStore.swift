//
//  FavoriteStore.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import CustomObservable

final class FavoriteStore {
    private(set) var changes = EagerObservable<Change>(source: .next(.none))
    
    enum Change {
        case added(id: String)
        case removed(id: String)
        case none
    }

    private let cache: UserFavoriteCache

    init(cache: UserFavoriteCache = .shared) {
        self.cache = cache
    }

    func set(_ model: PhotoModel) {
        self.cache.set(model)
        self.changes.source = .next(.added(id: model.id))
    }

    func remove(id: String) {
        self.cache.remove(id: id)
        self.changes.source = .next(.removed(id: id))
    }

    func isFavorite(_ id: String) -> Bool {
        cache.isFavorite(id: id)
    }
}
