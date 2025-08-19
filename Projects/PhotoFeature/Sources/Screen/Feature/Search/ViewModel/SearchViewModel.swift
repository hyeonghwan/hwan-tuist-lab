//
//  SearchViewModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/15/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//


import CustomObservable

final class SearchViewModel {
    
    struct Input {
        var selectedTagTrigger: LazyObservable<TagModel?>
        var selectedFilterTrigger: LazyObservable<String>
        var sendQueryTrigger: LazyObservable<String>
        var pagingTrigger: LazyObservable<Void>
        var reloadFinishTrigger: LazyObservable<Void>
        var filterButtonTrigger: EagerObservable<String>
    }
    
    struct Output {
        var viewState: EagerObservable<ViewState>
        var photoResultState: EagerObservable<[PhotoModel]>
    }
    
    struct ViewState: Equatable {
        var totalPage: Int = 1
        var page: Int = 0
        let per_page: Int = 20
        var selectedTag: TagModel?
        var loading: Bool = true
        var query: String?
        var order_by: String?
        
        mutating func mutate(_ value: (inout ViewState) -> Void) {
            value(&self)
        }
    }
    
    private let provider: SearchProvider
    
    init(provider: SearchProvider) {
        self.provider = provider
    }
    
    private(set) var viewState = EagerObservable<ViewState>(source: .next(.init(selectedTag: nil)))
    private(set) var photoResultState = EagerObservable<[PhotoModel]>(source: .next([]))
    private var bag = Bag()
    
    func transform(input: Input) -> Output {
        input.reloadFinishTrigger
            .subscribeOn { [weak self] _ in
                if var state = self?.viewState.value {
                    state.loading = false
                    self?.viewState.source = .next(state)
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
                case .success(let success):
                    var viewState = self.viewState.value
                    let photoModel = success.results.map {
                        $0.toModel()
                    }
                    
                    self.photoResultState.source = .next(photoModel)
                    
                    viewState.mutate { state in
                        state.totalPage = success.totalPages
                        state.page = 1
                        state.query = query
                    }
                    
                    self.viewState.source = .next(viewState)
                    
                case .failure(let failure):
                    print(failure)
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
                
                Task {
                    await self.pagingUpdate()
                }
            }
            .disposed(in: bag)
        
        
        return Output(
            viewState: viewState,
            photoResultState: photoResultState
        )
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
            case .success(let success):
                let photoModel = success.results.map { $0.toModel() }
                let origin = self.photoResultState.value
                
                self.photoResultState.source = .next(origin + photoModel)
                
                state.mutate { state in
                    state.page += 1
                }
                
                self.viewState.source = .next(state)
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func resetQuery(query: String) -> SearchQuery {
        var state = viewState.value
        
        state.mutate { state in
            state.page = 0
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
        
        if state.page + 1 <= state.totalPage {
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
