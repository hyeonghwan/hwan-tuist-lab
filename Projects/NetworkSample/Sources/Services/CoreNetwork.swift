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

final class CoreNetwork {
    private let session = URLSession(configuration: .default)
    static let shared = CoreNetwork()
    
    class API {
        static let session: Session = {
            let configuration = URLSessionConfiguration.af.default
            let apiLogger = APIEventLogger()
            return Session(configuration: configuration, eventMonitors: [apiLogger])
        }()
    }

    private init() {}
    
    func GET<Resource, DTO>(
        resource: Resource,
        type: DTO.Type,
        completion: @escaping (Result<DTO, Error>) -> Void) where Resource: APIResource, DTO: Codable
    {
        do {
            let urlRequest = try resource.urlRequest()
            API.session.request(urlRequest, interceptor: .retryPolicy)
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
    
    func put() {
        
    }
    
    func patch() {
        
    }
    
    func delete() {
        
    }
}
