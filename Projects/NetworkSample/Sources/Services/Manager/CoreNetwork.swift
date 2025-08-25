//
//  CoreNetwork.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Alamofire


protocol AsyncNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType,
                                                    decoder: JSONDecoder?) async -> Result<DTO, any Error>
}

extension AsyncNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType = .default,
                                                    decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        await self.GET(resource: resource, decodeType: decodeType, using: profile, decoder: decoder)
    }
}

protocol CallbackNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType,
                                                    decoder: JSONDecoder?,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
}

extension CallbackNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType = .default,
                                                    decoder: JSONDecoder? = nil,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
    {
        self.GET(resource: resource, decodeType: decodeType, using: profile, decoder: decoder, completion: completion)
    }
}


#if canImport(Combine)
import Combine
protocol CombineNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType,
                                                    decoder: JSONDecoder?) -> AnyPublisher<DTO, Error>
}

extension CombineNetwork {
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType = .default,
                                                    decoder: JSONDecoder? = nil) -> AnyPublisher<DTO, Error>
    {
        self.GET(resource: resource, decodeType: decodeType, using: profile, decoder: decoder)
    }
}
#endif

typealias NetworkManager = AsyncNetwork & CallbackNetwork & CombineNetwork

final class CoreNetwork: NetworkManager {
    static let shared: NetworkManager = CoreNetwork(
        registry: .init(
            monitor: APIEventLogger()
        ),
        decoder: JSONDecoder()
    )
    
    private let defaultDecoder: JSONDecoder
    private var registry: AFSessionRegistry
    
    init(registry: AFSessionRegistry,
         decoder: JSONDecoder = .init()) {
        self.registry = registry
        self.defaultDecoder = decoder
    }
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType = .default,
                                                    decoder: JSONDecoder? = nil,
                                                    completion: @escaping (Result<DTO, Error>) -> Void)
    {
        do {
            let urlRequest = try resource.urlRequest()
            let session = registry.session(for: profile)
            
            session.request(urlRequest, interceptor: .retryPolicy)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DTO.self, decoder: decoder ?? defaultDecoder) { result in
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
                                                    using profile: SessionType = .default,
                                                    decoder: JSONDecoder? = nil) async -> Result<DTO, any Error>
    {
        do {
            let req = try resource.urlRequest()
            let session = registry.session(for: profile)
            
            let dataTask = session.request(req, interceptor: .retryPolicy)
                .validate(statusCode: 200..<300)
                .serializingDecodable(DTO.self, decoder: decoder ?? self.defaultDecoder)
            
            let value = try await dataTask.value
            return .success(value)
        } catch {
            return .failure(error)
        }
    }
    
    func GET<Resource: APIResource, DTO: Decodable>(resource: Resource,
                                                    decodeType: DTO.Type,
                                                    using profile: SessionType = .default,
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


enum SessionType: Hashable {
    case `default`
    case ephemeral
}


final class AFSessionRegistry {
    private var store: [SessionType: Session] = [:]
    private let lock = NSLock()
    private let monitor: EventMonitor?
    
    init(monitor: EventMonitor) {
        self.monitor = monitor
    }
    
    func session(for profile: SessionType) -> Session {
        lock.lock()
        
        defer {
            lock.unlock()
        }
        
        if let session = store[profile] {
            return session
        }
        
        let session = makeSession(profile)
        store[profile] = session
        
        return session
    }
    
    private func makeSession(_ profile: SessionType) -> Session {
        switch profile {
        case .default:
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 15
            return Session(configuration: configuration, eventMonitors: monitor == nil ? [] : [monitor!])
            
        case .ephemeral:
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpShouldSetCookies = false
            return Session(configuration: configuration, eventMonitors: monitor == nil ? [] : [monitor!])
        }
    }
}
