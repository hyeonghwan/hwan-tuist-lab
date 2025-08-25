//
//  Disposables.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

protocol Disposables {
    var id: UUID { get }
    
    /// do not Call this method directly
    /// - Parameter id: Observer ID
    func dispose(id: UUID)
    
    func disposed(in bag: Bag)
}

struct DefaultDisposables: Hashable, Equatable, Disposables {
    let id: UUID
    let disposables: Disposables
    
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func dispose() {
        self.disposables.dispose(id: self.id)
    }
    
    func dispose(id: UUID) {
        self.disposables.dispose(id: id)
    }
    
    func disposed(in bag: Bag) {
        bag.insert(self)
    }
}


final class Bag {
    var subscriptions = Set<DefaultDisposables>()
    var isDisposed: Bool = false
    
    func insert(_ disposables: DefaultDisposables) {
        if isDisposed {
            disposables.dispose()
        } else {
            subscriptions.insert(disposables)
        }
    }
    
    func dispose() {
        self.isDisposed = true
        for subscription in subscriptions {
            subscription.dispose()
        }
    }
    
    deinit { dispose() }
}

