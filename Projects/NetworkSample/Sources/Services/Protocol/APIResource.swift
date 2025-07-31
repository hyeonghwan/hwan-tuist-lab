//
//  API.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIResource {
    associatedtype ResponseType: Decodable
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var API_KEY: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var query: Query { get }
}

extension APIResource {
    var scheme: String { "https" }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { nil }
    var API_KEY: String { "" }
    
    func urlRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        var queries = self.query.makeQuery()
        
        if !self.API_KEY.isEmpty {
            queries["key"] = self.API_KEY
        }
        
        components.queryItems = queries.reduce(into: [URLQueryItem]()) { origin, next in
            origin.append(URLQueryItem(name: next.key, value: next.value))
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
