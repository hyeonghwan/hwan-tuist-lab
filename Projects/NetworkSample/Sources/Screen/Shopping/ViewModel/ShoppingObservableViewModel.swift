//
//  ShoppingViewModel.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Combine

final class ShoppingObservableViewModel {
    
    struct Model {
        var list: [ShoppingItemDTO]
    }
    
    // MARK: Input
    let viewDidLoadMergeWithRetryLoadTrigger = HotObservable<ShoppingSortType>(source: ShoppingSortType.sim)
    let pagingTrigger = ColdObservable<Void>.void
    let sortTypeButtonTrigger = ColdObservable<ShoppingSortType>()
    let refreshTrigger = ColdObservable<ShoppingSortType>()
    
    // MARK: Output
    let loadModelSignal = ColdObservable<Void>()
    let pagingSignal = ColdObservable<Void>()
    let refreshSignal = ColdObservable<Void>()
    let isLoadingCell = HotObservable<Bool>(source: true)
    let isLoadingPagingIndicator = HotObservable<Bool>(source: false)
    let guardPaging = HotObservable<Bool>(source: true)
    let shoppingListSubject = HotObservable<Model>(source: .init(list: []))
    let totalCount = ColdObservable<Int>()
    let dataLoadFailed = ColdObservable<Error>()

    private var bag = Bag()
    
    var shoppintList: [ShoppingItemDTO] { self.shoppingListSubject.source.list }
    var lodingPaging: Bool { isLoadingPagingIndicator.source }
    
    // MARK: Dependency
    private let provider: ShoppingProvider
    private var paginagState: PagingState
    private var isPagingEnabled: Bool = false
    
    init(dependency: ShoppingProvider = .liveValue, initialState: PagingState) {
        self.provider = dependency
        self.paginagState = initialState
    }
    
    func viewModelBinding() {
        refreshTrigger
            .subscribeAsync { [weak self] type in
                guard let viewModel = self else { return }
                viewModel._setGuardPaging()
                try? await Task.sleep(for: .milliseconds(300))
                let result = await viewModel.fetchLoad(sortType: type)
                await MainActor.run {
                    viewModel.refresh(tuple: result)
                }
            }
            .disposed(in: bag)
        
        sortTypeButtonTrigger
            .subscribeAsync { [weak self] type in
                guard let viewModel = self else { return }
                viewModel._setLoadingCell()
                Debouncer(delay: 0.03).run {
                    let result = await viewModel.fetchLoad(sortType: type)
                    await MainActor.run {
                        viewModel.load(tuple: result)
                    }
                }
            }
            .disposed(in: bag)
        
        viewDidLoadMergeWithRetryLoadTrigger
            .subscribeAsync { [weak self] type in
                guard let viewModel = self else { return }
                viewModel._setLoadingCell()
                let result = await viewModel.fetchLoad(sortType: type)
                await MainActor.run {
                    viewModel.load(tuple: result)
                }
            }
            .disposed(in: bag)
        
        pagingTrigger
            .subscribeAsync { [weak self] flag in
                guard let self, self.isPagingEnabled else {
                    return
                }
                self._setPagingLoading()
                guard let dto = await self.requestNextPageIfPossible() else {
                    return
                }
                await MainActor.run {
                    let originDTO = self.shoppingListSubject.source
                    let total = originDTO.list + dto.data.items
                    self.shoppingListSubject.source = Model(list: total)
                    self.pagingSignal.source(())
                }
            }
            .disposed(in: bag)
    }
    
    private func fetchLoad(sortType: ShoppingSortType) async -> (ShoppingItemResultDTO, PagingState) {
        let initialPagingState = self.paginagState.loadInitialState(sortType: sortType)
        let result = await self.provider.fetchWithTask(initialPagingState.asQuery())
        switch result {
        case let .success(dto):
            return (dto, initialPagingState)
            
        case let .failure(error):
            self.dataLoadFailed.source(error)
            let emptyResponse = ShoppingItemResultDTO(data: NaverSearchResultDTO(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
            return (emptyResponse, initialPagingState)
        }
    }
    
    private  func requestNextPageIfPossible() async -> ShoppingItemResultDTO? {
        guard let state = self.paginagState.nextState() else {
            self.isPagingEnabled = false
            return nil
        }
        let result = await self.provider.fetchWithTask(state.asQuery())
        switch result {
        case let .success(dto):
            return dto
        case .failure:
            return ShoppingItemResultDTO(data: NaverSearchResultDTO(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
        }
    }
    
    private func load(tuple: (ShoppingItemResultDTO, PagingState)) {
        updateViewModel(tuple: tuple)
        self.loadModelSignal.source(())
    }
    
    private func refresh(tuple: (ShoppingItemResultDTO, PagingState)) {
        updateViewModel(tuple: tuple)
        self.refreshSignal.source(())
    }
    
    private func updateViewModel(tuple: (ShoppingItemResultDTO, PagingState)) {
        let (resultDTO, intialPagingState) = tuple
        self.paginagState = PagingState(
            query: intialPagingState.query,
            display: intialPagingState.pagingDisplay,
            start: intialPagingState.start,
            sort: intialPagingState.sort,
            currentPage: resultDTO.data.items.count,
            total: resultDTO.data.total
        )
        self.isPagingEnabled = self.paginagState.isPagingEnabled
        self.shoppingListSubject.source = Model(list: resultDTO.data.items)
        self.totalCount.source(resultDTO.data.total)
    }
    
    func _setGuardPaging() {
        self.guardPaging.source = true
    }
    
    func _setLoadingCell() {
        guardPaging.source = true
        isLoadingCell.source = true
    }
    
    func _setPagingLoading() {
        guardPaging.source = true
        isLoadingPagingIndicator.source = true
    }
}

extension ShoppingObservableViewModel {
    struct PagingState {
        var query: String
        var display: Int
        var start: Int
        var sort: ShoppingSortType
        var currentPage: Int
        var total: Int
        
        var initialLoadDisplay: Int { 100 }
        var pagingDisplay: Int { 30 }
        
        var isPagingEnabled: Bool {
            currentPage < total
        }
        
        func loadInitialState(sortType: ShoppingSortType) -> Self {
            PagingState(
                query: self.query,
                display: initialLoadDisplay,
                start: 1,
                sort: sortType,
                currentPage: -1,
                total: self.total
            )
        }
        
        mutating func nextState() -> Self? {
            let nextStart = currentPage + 1
            if nextStart > total {
                return nil
            }
            
            let nextPage = self.currentPage + self.pagingDisplay
            let isNextPagingPossible = nextPage <= self.total
            if isNextPagingPossible {
                return PagingState(
                    query: self.query,
                    display: self.pagingDisplay,
                    start: nextStart,
                    sort: self.sort,
                    currentPage: nextPage,
                    total: self.total
                )
            }
            
            let remainCount = self.total - currentPage
            let isLastPage = remainCount > 0
            if isLastPage {
                return PagingState(
                    query: self.query,
                    display: self.pagingDisplay,
                    start: nextStart,
                    sort: self.sort,
                    currentPage: self.currentPage + remainCount,
                    total: self.total
                )
            }
            return nil
        }
        
        func asQuery() -> ShoppingSearchQuery {
            ShoppingSearchQuery(
                query: self.query,
                display: self.display,
                start: self.start,
                sort: self.sort.string
            )
        }
    }
}
