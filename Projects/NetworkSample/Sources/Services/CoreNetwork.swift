//
//  CoreNetwork.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Alamofire
import Combine

// @Logging
final class CoreNetwork {
    private let session = URLSession(configuration: .default)
    static let shared = CoreNetwork()
    
    private init() {}
    
    func get<Resource, DTO>(resource: Resource, type: DTO.Type, queries: [String: String], completion: @escaping (Result<DTO, Error>) -> Void) where Resource: APIResource, DTO: Codable {
        do {
            let urlRequest = try resource.urlRequest(queries: queries)
            AF.request(urlRequest, interceptor: .retryPolicy)
                .responseDecodable(of: DTO.self) { result in
                    switch result.result {
                    case let .success(dto):
                        completion(.success(dto))
                        
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }
    
    func get(destination url: URL) {
        
    }
    
    func put() {
        
    }
    
    func patch() {
        
    }
    
    func delete() {
        
    }
}
