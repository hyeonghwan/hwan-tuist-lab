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

protocol NetworkManager {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder?,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder?) async -> Result<DTO, any Error>
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder?) -> AnyPublisher<DTO, any Error>
}

extension NetworkManager {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
    {
        self.GET(resource: resource, decodeType: decodeType, decoder: decoder, completion: completion)
    }
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        await self.GET(resource: resource, decodeType: decodeType, decoder: decoder)
    }
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil) -> AnyPublisher<DTO, any Error>
    {
        self.GET(resource: resource, decodeType: decodeType, decoder: decoder)
    }
}

final class CoreNetwork: NetworkManager {
    static let shared: NetworkManager = CoreNetwork()
    
    private let defaultDecorder = JSONDecoder()
    
    private class API {
        static let session: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 5
            let apiLogger = APIEventLogger()
            return Session(configuration: configuration, eventMonitors: [apiLogger])
        }()
    }

    fileprivate init() {}
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
    {
        do {
            let urlRequest = try resource.urlRequest()
            API.session.request(urlRequest, interceptor: .retryPolicy)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DTO.self, decoder: decoder == nil ? defaultDecorder : decoder!) { result in
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
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        await withCheckedContinuation { continuation in
            self.GET(
                resource: resource,
                decodeType: decodeType,
                decoder: decoder,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }
    }
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    decoder: JSONDecoder? = nil) -> AnyPublisher<DTO, any Error>
    {
        Deferred {
            Future<DTO, any Error> { promise in
                self.GET(
                    resource: resource,
                    decodeType: decodeType,
                    decoder: decoder,
                    completion: { result in
                        promise(result)
                    }
                )
            }
        }
        .eraseToAnyPublisher()
    }
    
    func put() {
        
    }
    
    func patch() {
        
    }
    
    func delete() {
        
    }
}
