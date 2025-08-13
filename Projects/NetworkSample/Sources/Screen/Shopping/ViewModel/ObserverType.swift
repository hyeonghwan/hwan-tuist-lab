//
//  ObserverType.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

protocol ObserverType: AnyObject, Hashable {
    associatedtype Element
    var id: UUID { get set }
    func receive(_ element: Event<Element>)
}

extension ObserverType {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
