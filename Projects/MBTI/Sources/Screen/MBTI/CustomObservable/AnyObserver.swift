//
//  AnyObserver.swift
//  NetworkSample
//
//  Created by hwan on 8/12/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

final class AnyObserver<Element>: ObserverType {
    var id: UUID = UUID()
    var handler: ((Event<Element>) -> Void)?
    
    init(handler: (@escaping (Event<Element>) -> Void)) {
        self.handler = handler
    }
    
    func receive(_ element: Event<Element>) {
        self.handler?(element)
    }
}
