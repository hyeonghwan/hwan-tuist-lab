//
//  TopicProvider.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import APIClient


final class TopicProvider {
    private let client: DefaultAPIClient
    
    init(_ client: DefaultAPIClient) {
        self.client = client
    }
    
    func fetch(_ topic: Topic) async -> Result<[TopicPhotoDTO], any Error> {
        let resource = TopicAPIResource(topic: topic)
        let result = await client.execute(
            resource: resource,
            decodeType: [TopicPhotoDTO].self
        )
        return result
    }
    
    
    final class UncheckedBox: @unchecked Sendable {
        let lock = NSLock()
        var fetchResults = [Int: Result<[TopicPhotoDTO], any Error>]()
        
        init() { }
        
        func insert(index: Int, result: Result<[TopicPhotoDTO], any Error>) {
            lock.lock()
            self.fetchResults[index] = result
            lock.unlock()
        }
    }
    
    func fetchGroup(topicList: [Topic], _ completion: @escaping ([Result<[TopicPhotoDTO], any Error>]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let box = UncheckedBox()
        
        for index in 0..<topicList.count {
            
            dispatchGroup.enter()
            
            let resource = TopicAPIResource(topic: topicList[index])
            client.execute(
                resource: resource,
                decodeType: [TopicPhotoDTO].self
            ) { result in
                box.insert(index: index, result: result)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(box.fetchResults.sorted(by: { $0.key < $1.key }).map(\.value))
        }
    }
}
