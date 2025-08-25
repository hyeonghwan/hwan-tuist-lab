//
//  PhotoStatProvider.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient

final class PhotoStatProvider {
    private let client: DefaultAPIClient
    
    init(_ client: DefaultAPIClient) {
        self.client = client
    }
    
    func getStats(id: String) async -> Result<StatsResponseDTO, any Error> {
        let resource = PhotoStatAPIResource.init(id: id)
        let result = await client.execute(
            resource: resource,
            decodeType: StatsResponseDTO.self
        )
        return result
    }
}
