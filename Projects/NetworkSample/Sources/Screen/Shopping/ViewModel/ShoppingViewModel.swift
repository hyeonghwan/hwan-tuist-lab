//
//  ShoppingViewModel.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Combine

final class ShoppingViewModel {
    
    struct Model {
        var list: [ShoppingItemDTO]
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<ShoppingSortType, Never>
        let pagingRequest: AnyPublisher<Void, Never>
        let sortTypeButtonTapped: AnyPublisher<ShoppingSortType, Never>
        let refreshRequest: AnyPublisher<ShoppingSortType, Never>
        let retryLoadSubject: AnyPublisher<ShoppingSortType, Never>
    }
    
    struct Output {
        let loadModelSignal: AnyPublisher<Void, Never>
        let refreshSignal: AnyPublisher<Void, Never>
        let pagingSignal: AnyPublisher<Void, Never>
        let pagingResult: AnyPublisher<Model, Never>
        let totalCount: AnyPublisher<Int, Never>
        let dataLoadFailed: AnyPublisher<Error, Never>
        let isLoadingCell: AnyPublisher<Bool, Never>
        let isLoadingPagingIndicator: AnyPublisher<Bool, Never>
        let guardPaging: AnyPublisher<Bool, Never>
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Output Subject
    private let loadModelSignal = PassthroughSubject<Void, Never>()
    private let pagingSignal = PassthroughSubject<Void, Never>()
    private let refreshSignal = PassthroughSubject<Void, Never>()
    
    private(set) var isLoadingCell = CurrentValueSubject<Bool, Never>(true)
    private(set) var isLoadingPagingIndicator = CurrentValueSubject<Bool, Never>(false)
    private(set) var guardPaging = CurrentValueSubject<Bool, Never>(true)
    
    private let shoppingListSubject = CurrentValueSubject<Model, Never>(Model(list: []))
    private let totalCount = PassthroughSubject<Int, Never>()
    private let dataLoadFailed = PassthroughSubject<Error, Never>()
    
    var shoppintList: [ShoppingItemDTO] { self.shoppingListSubject.value.list }
    var lodingPaging: Bool { isLoadingPagingIndicator.value }
    
    // MARK: Dependency
    private let provider: ShoppingProvider
    private var paginagState: PagingState
    private var isPagingEnabled: Bool = false
    
    init(dependency: ShoppingProvider = .liveValue, initialState: PagingState) {
        self.provider = dependency
        self.paginagState = initialState
    }

    func transform(_ input: Input) -> Output {
        input.refreshRequest
            .setGuardPaging(on: self)
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .withUnretained(self)
            .flatMap { viewModel, sortType in
                viewModel.fetchLoad(sortType: sortType)
            }
            .sinkWeak(on: self) { viewModel, tuple in
                viewModel.refresh(tuple: tuple)
            }
            .store(in: &subscriptions)
        
        let sortTypeButtonTapped = input.sortTypeButtonTapped
            .setLoadingCell(on: self)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .withUnretained(self)
            .flatMap { viewModel, sortType in
                viewModel.fetchLoad(sortType: sortType)
            }
            .eraseToAnyPublisher()
        
        let loadPublisher = Publishers.Merge(input.viewDidLoad,input.retryLoadSubject)
            .setLoadingCell(on: self)
            .withUnretained(self)
            .flatMap { viewModel, sortType in
                viewModel.fetchLoad(sortType: sortType)
            }
            .eraseToAnyPublisher()
        
        Publishers.MergeMany(sortTypeButtonTapped, loadPublisher)
            .sinkWeak(on: self) { viewModel, tuple in
                viewModel.loadSignal(tuple: tuple)
            }
            .store(in: &subscriptions)

        input.pagingRequest
            .filter(to: \.isPagingEnabled, on: self)
            .setPagingLoading(on: self)
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.requestNextPageIfPossible()
                    .map(\.data.items)
            }
            .sinkWeak(on: self) { viewModel, list in
                let originDTO = viewModel.shoppingListSubject.value
                let total = originDTO.list + list
                viewModel.shoppingListSubject.send(Model(list: total))
                viewModel.pagingSignal.send()
            }
            .store(in: &subscriptions)
        
        return Output(
            loadModelSignal: loadModelSignal.eraseToAnyPublisher(),
            refreshSignal: refreshSignal.eraseToAnyPublisher(),
            pagingSignal: pagingSignal.eraseToAnyPublisher(),
            pagingResult: shoppingListSubject.eraseToAnyPublisher(),
            totalCount: totalCount.eraseToAnyPublisher(),
            dataLoadFailed: dataLoadFailed.eraseToAnyPublisher(),
            isLoadingCell: isLoadingCell.eraseToAnyPublisher(),
            isLoadingPagingIndicator: isLoadingPagingIndicator.eraseToAnyPublisher(),
            guardPaging: guardPaging.eraseToAnyPublisher()
        )
    }
    
    private func fetchLoad(sortType: ShoppingSortType) -> AnyPublisher<(ShoppingItemResultDTO, PagingState), Never> {
        let intialPagingState = self.paginagState.loadInitialState(sortType: sortType)
        
        return self.provider.fetchWithPublisher(intialPagingState.asQuery())
            .map { apiResponse in
                (apiResponse, intialPagingState)
            }
            .catch { error -> AnyPublisher<(ShoppingItemResultDTO, PagingState), Never> in
                self.dataLoadFailed.send(error)
                
                let emptyResponse = ShoppingItemResultDTO(data: NaverSearchResultDTO(lastBuildDate: "", total: 0, start: 0, display: 0, items: []))
                
                return Just((emptyResponse, intialPagingState))
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func loadSignal(tuple: (ShoppingItemResultDTO, PagingState)) {
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
        self.shoppingListSubject.send(Model(list: resultDTO.data.items))
        self.totalCount.send(resultDTO.data.total)
        
        self.loadModelSignal.send()
    }
    
    private func refresh(tuple: (ShoppingItemResultDTO, PagingState)) {
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
        self.shoppingListSubject.send(Model(list: resultDTO.data.items))
        self.totalCount.send(resultDTO.data.total)
        self.refreshSignal.send()
    }
    
    
    private  func requestNextPageIfPossible() -> AnyPublisher<ShoppingItemResultDTO, Never> {
        guard let state = self.paginagState.nextState() else {
            self.isPagingEnabled = false
            return Empty<ShoppingItemResultDTO, Never>().eraseToAnyPublisher()
        }
        return self.provider.fetchWithPublisher(state.asQuery())
            .replaceError(with: ShoppingItemResultDTO(data: NaverSearchResultDTO(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])))
            .eraseToAnyPublisher()
    }
}

extension ShoppingViewModel {
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

private extension Publisher where Failure == Never {
    func setGuardPaging(on object: ShoppingViewModel) -> AnyPublisher<Self.Output, Never> {
        self.handleEvents(receiveOutput: { [weak object] _ in
            object?.guardPaging.send(true)
        })
        .eraseToAnyPublisher()
    }
    
    func setLoadingCell(on object: ShoppingViewModel) -> AnyPublisher<Self.Output, Never> {
        self.handleEvents(receiveOutput: { [weak object] _ in
            object?.guardPaging.send(true)
            object?.isLoadingCell.send(true)
        })
        .eraseToAnyPublisher()
    }
    
    func setPagingLoading(on object: ShoppingViewModel) -> AnyPublisher<Self.Output, Never> {
        self.handleEvents(receiveOutput: { [weak object] _ in
            object?.guardPaging.send(true)
            object?.isLoadingPagingIndicator.send(true)
        })
        .eraseToAnyPublisher()
    }
}
