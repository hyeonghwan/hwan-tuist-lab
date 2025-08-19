//
//  SearchDetailViewModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import CustomObservable

final class SearchDetailViewModel {
    
    // MARK: Inptut
    var viewDidLoad = LazyObservable<Void>()
    var changeGraphTrigger = LazyObservable<String>()
    
    
    // MARK: Output
    var stats = LazyObservable<StatsResponseDTO>()
    var errorHandle = LazyObservable<String>()
    
    var provider: PhotoStatProvider
    private var bag = Bag()
    var model: PhotoModel
    
    init(
        provider: PhotoStatProvider,
        model: PhotoModel
    ) {
        self.provider = provider
        self.model = model
    }
    
    func transform() {
        viewDidLoad.subscribeAsync { [weak self] _ in
            guard let self else { return }
            
            let result = await self.provider.getStats(id: self.model.id)
            switch result {
            case .success(let success):
                self.stats.source(.next(success))
                
            case .failure(let failure):
                self.errorHandle.source(.next(failure.localizedDescription))
            }
        }
        .disposed(in: bag)
    }
}
