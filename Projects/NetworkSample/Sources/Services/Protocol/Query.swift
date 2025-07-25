//
//  keep.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation


protocol Query {
    func makeQuery() -> [String: String]
}

extension Query {
    func makeQuery() -> [String : String] {
        let mirror = Mirror(reflecting: self)
        var result = [String: String]()
        for property in mirror.children {
            if let label = property.label {
                result[label] = "\(property.value)"
            }
        }
        return result
    }
}

struct EmptyQuery: Query {
    func makeQuery() -> [String : String] {
        [:]
    }
}
