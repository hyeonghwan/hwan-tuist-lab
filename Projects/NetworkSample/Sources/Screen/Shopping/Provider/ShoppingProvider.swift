//
//  ShoppingProvider.swift
//  NetworkSample
//
//  Created by hwan on 7/27/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Combine

struct ShoppingProvider {
    var fetchWithClosure: (_ query: ShoppingSearchQuery,
                           _ completion: @escaping (Result<ShoppingItemResultDTO, any Error>) -> Void) -> Void
    
    // var fetchGroup: ()
    
    var fetchWithTask: (_ query: ShoppingSearchQuery) async -> Result<ShoppingItemResultDTO, any Error>
    
    var fetchWithPublisher: (_ query: ShoppingSearchQuery) -> AnyPublisher<ShoppingItemResultDTO, any Error>
}

extension ShoppingProvider {
    static func makeResource(_ start: Int, _ display: Int, _ query: String, _ sort: ShoppingSortType) -> NaverShoppingSearchApiResource {
        NaverShoppingSearchApiResource(
            query: ShoppingSearchQuery(
                query: query,
                display: display,
                start: start,
                sort: sort.string
            )
        )
    }
    
    static func makeResource(query: ShoppingSearchQuery) -> NaverShoppingSearchApiResource {
        NaverShoppingSearchApiResource(
            query: query
        )
    }
}

extension ShoppingProvider {
    static let liveValue = ShoppingProvider(
        fetchWithClosure: { query, completion in
            CoreNetwork.shared.GET(
                resource: makeResource(query: query),
                decodeType: ShoppingItemResultDTO.self,
                completion: completion
            )
        },
        fetchWithTask: { query in
            await CoreNetwork.shared.GET(
                resource: makeResource(query: query),
                decodeType: ShoppingItemResultDTO.self
            )
        },
        fetchWithPublisher: { query in
            CoreNetwork.shared.GET(
                resource: makeResource(query: query),
                decodeType: ShoppingItemResultDTO.self
            )
        }
    )
    
    static let testValue = ShoppingProvider(
        fetchWithClosure: { query, completion  in
            
        },
        fetchWithTask: { query in
            await Task.detached {
                return Result<ShoppingItemResultDTO, any Error>.init(
                    catching: {
                        ShoppingItemResultDTO(
                            data: NaverSearchResultDTO(
                                lastBuildDate: "sdfsdfsf",
                                total: 1,
                                start: 0,
                                display: 1,
                                items: []
                            )
                        )
                    }
                )
            }.value
        },
        fetchWithPublisher: { query in
            Deferred {
                Future<ShoppingItemResultDTO, any Error> { promise in
                    promise(
                        Result<ShoppingItemResultDTO, any Error>.init(
                            catching: {
                                ShoppingItemResultDTO(
                                    data: NaverSearchResultDTO(
                                        lastBuildDate: "sdfsdfsf",
                                        total: 1,
                                        start: 0,
                                        display: 1,
                                        items: []
                                    )
                                )
                            }
                        )
                    )
                }
            }
            .eraseToAnyPublisher()
        }
    )
}
