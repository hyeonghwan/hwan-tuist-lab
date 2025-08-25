//
//  SearchViewModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/15/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import CustomObservable

final class SearchViewModel {
    struct Input {
        var selectedTagTrigger: LazyObservable<TagModel?>
        var selectedFilterTrigger: LazyObservable<String>
        var sendQueryTrigger: LazyObservable<String>
        var pagingTrigger: LazyObservable<Void>
        var reloadFinishTrigger: LazyObservable<Void>
        var filterButtonTrigger: EagerObservable<String>
        var favoriteButtonTrigger: LazyObservable<(path: IndexPath, isFavorite: Bool)>
    }
    
    struct Output {
        var viewState: EagerObservable<ViewState>
        var photoResultState: EagerObservable<(model: [PhotoModel], isUpdate: Bool)>
        var errorHandle: LazyObservable<APIError>
    }
    
    struct ViewState: Equatable {
        var totalPage: Int = 1
        var page: Int = 1
        let per_page: Int = 20
        var selectedTag: TagModel?
        var loading: Bool = true
        var query: String?
        var order_by: String?
        
        mutating func mutate(_ value: (inout ViewState) -> Void) {
            value(&self)
        }
    }
    
    private let favoriteStore: FavoriteStore
    private let provider: SearchProvider
    private(set) var viewState = EagerObservable<ViewState>(source: .next(.init(selectedTag: nil)))
    private(set) var photoResultState = EagerObservable<(model: [PhotoModel], isUpdate: Bool)>(source: .next(([], true)))
    private(set) var isLoadingPagingIndicator = EagerObservable<Bool>(source: .next(false))
    private var errorHandle = LazyObservable<APIError>()
    
    private var bag = Bag()
    
    init(favoriteStore: FavoriteStore, provider: SearchProvider) {
        self.favoriteStore = favoriteStore
        self.provider = provider
    }
    
    func transform(input: Input) -> Output {
        favoriteStore.changes
            .subscribeOn { [weak self] changes in
                guard let self else { return }
                self.favoriteBinding(changes: changes)
            }
            .disposed(in: bag)
        
        input.favoriteButtonTrigger
            .subscribeOn { [weak self] tuple in
                let (indexPath, isFavorite) = tuple
                guard let self else { return }
                
                let (models, _) = self.photoResultState.value
                
                let model = models[indexPath.row]
                
                if isFavorite {
                    self.favoriteStore.set(model)
                } else {
                    self.favoriteStore.remove(id: model.id)
                }
            }
            .disposed(in: bag)
        
        input.reloadFinishTrigger
            .subscribeOn { [weak self] _ in
                if var state = self?.viewState.value {
                    state.loading = false
                    self?.viewState.source = .next(state)
                    self?.isLoadingPagingIndicator.source = .next(false)
                }
            }
            .disposed(in: bag)
        
        input.selectedTagTrigger
            .subscribeOn { [weak self] value in
                if var viewState = self?.viewState.value
                {
                    viewState.mutate { state in
                        state.selectedTag = value
                    }
                    self?.viewState.source = .next(viewState)
                }
            }
            .disposed(in: bag)
        
        input.filterButtonTrigger
            .subscribeOn { [weak self] filterOrderBy in
                if var viewState = self?.viewState.value
                {
                    viewState.mutate { state in
                        state.order_by = filterOrderBy
                    }
                    self?.viewState.source = .next(viewState)
                }
            }
            .disposed(in: bag)
        
        input.sendQueryTrigger
            .subscribeAsync { [weak self] query in
                guard let self else { return }
                let searchQuery = self.resetQuery(query: query)
                let result = await self.provider.search(searchQuery)
                
                switch result {
                case let .success(success):
                    var viewState = self.viewState.value
                    let photoModel = success.results.map {
                        $0.toModel()
                    }
                    
                    self.photoResultState.source = .next((photoModel, true))
                    
                    viewState.mutate { state in
                        state.totalPage = success.totalPages
                        state.page = 2
                        state.query = query
                    }
                    
                    self.viewState.source = .next(viewState)
                    
                case let .failure(error):
                    let apiError = APIError.map(error)
                    self.errorHandle.source(.next(apiError))
                }
            }
            .disposed(in: bag)
        
        input.pagingTrigger
            .subscribeOn { [weak self] _ in
                guard let self else { return }
                var state = self.viewState.value
                
                if state.loading == true {
                    return
                }
                
                state.loading = true
                
                self.viewState.source = .next(state)
                self.isLoadingPagingIndicator.source = .next(true)
                
                Task {
                    await self.pagingUpdate()
                }
            }
            .disposed(in: bag)
        
        
        return Output(
            viewState: viewState,
            photoResultState: photoResultState,
            errorHandle: errorHandle
        )
    }
    
    private func favoriteBinding(changes: FavoriteStore.Change) {
        switch changes {
        case let .added(id: id):
            var (photos, _) = self.photoResultState.value
            
            if let idx = photos.firstIndex(where: { $0.id == id }) {
                photos[idx].userLike = true
                self.photoResultState.source = .next((photos, true))
            }
            
        case let .removed(id):
            var (photos, _) = self.photoResultState.value
            if let idx = photos.firstIndex(where: { $0.id == id }) {
                photos[idx].userLike = false
                self.photoResultState.source = .next((photos, true))
            }
        case .none:
            break
        }
    }
    
    private func pagingUpdate() async {
        var state = self.viewState.value
        
        guard let query = state.query else {
            state.loading = false
            self.viewState.source = .next(state)
            return
        }
        
        if let searchQuery = self.pagingQuery(query: query) {
            let result = await self.provider.search(searchQuery)
            switch result {
            case let .success(success):
                let photoModel = success.results.map { $0.toModel() }
                let (origin, _) = self.photoResultState.value
                
                self.photoResultState.source = .next((origin + photoModel, true))
                
                state.mutate { state in
                    state.page += 1
                }
                
                self.viewState.source = .next(state)
                
            case let .failure(error):
                let apiError = APIError.map(error)
                self.errorHandle.source(.next(apiError))
            }
        }
    }
    
    private func resetQuery(query: String) -> SearchQuery {
        var state = viewState.value
        
        state.mutate { state in
            state.page = 1
            state.totalPage = 1
        }
        
        viewState.source = .next(state)
        
        return SearchQuery(
            page: state.page,
            query: query,
            per_page: state.per_page,
            order_by: state.order_by,
            color: state.selectedTag?.color.rawValue
        )
    }
    
    private func pagingQuery(query: String) -> SearchQuery? {
        let state = viewState.value
        
        if state.page <= state.totalPage {
            let query = SearchQuery(
                page: state.page,
                query: query,
                per_page: state.per_page,
                order_by: state.order_by,
                color: state.selectedTag?.color.rawValue
            )
            return query
        }
        return nil
    }
}
