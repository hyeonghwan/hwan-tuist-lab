//
//  SearchProvider.swift
//  PhotoFeature
//
//  Created by hwan on 8/16/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient

final class SearchProvider {
    private let client: DefaultAPIClient
    
    init(_ client: DefaultAPIClient) {
        self.client = client
    }
    
    func search(_ query: SearchQuery) async -> Result<SearchResponseDTO, any Error> {
        let resource = SearchAPIResource(query: query)
        let result = await client.execute(
            resource: resource,
            decodeType: SearchResponseDTO.self
        )
        return result
    }
}
