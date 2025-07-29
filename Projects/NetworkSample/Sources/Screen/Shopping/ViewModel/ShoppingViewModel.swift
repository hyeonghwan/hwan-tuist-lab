//
//  ShoppingViewModel.swift
//  NetworkSample
//
//  Created by hwan on 7/26/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Combine
import HwanMacros

@Logging
final class ShoppingViewModel {
    
    struct Model {
        var list: [ShoppingItemDTO]
        var priorCount: Int
    }
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let pagingRequest: AnyPublisher<Void, Never>
        let sortTypeButtonTapped: AnyPublisher<Int, Never>
        let refreshRequest: AnyPublisher<Bool, Never>
    }
    
    struct Output {
        let isLoadingNextpage: AnyPublisher<Bool, Never>
        let pagingResult: AnyPublisher<Model, Never>
        let endRefresh: AnyPublisher<Void, Never>
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Output Subject
    private(set) var shoppingListSubject = CurrentValueSubject<Model, Never>(Model(list: [], priorCount: 0))
    private(set) var isLoadingNextPage = CurrentValueSubject<Bool, Never>(false)
    private let endRefreshSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Dependency
    private let provider: ShoppingProvider
    private var paginagState: PagingState
    private var isPagingEnabled: Bool = false
    
    init(dependency: ShoppingProvider = .liveValue, initialState: PagingState) {
        self.provider = dependency
        self.paginagState = initialState
    }
    
    private var dummyPublisher: AnyPublisher<[ShoppingItemDTO], NaverApiError> {
        Just<[ShoppingItemDTO]>((0...29).map { _ in .dummy })
            .setFailureType(to: NaverApiError.self)
            .eraseToAnyPublisher()
    }
    
    func transform(_ input: Input) -> Output {
        input.pagingRequest
            .handleEvents(receiveOutput: { [weak self] in
                self?.logger.log(level: .info, "\(#function)- receiveCancel apiLoading Set True to start")
                self?.isLoadingNextPage.send(true)
            })
            .withUnretained(self)
            .flatMap { (viewModel, _) in
                viewModel.provider.fetchWithPublisher(
                    viewModel.paginagState.asQuery()
                )
                .replaceError(with: .init(data: .init(lastBuildDate: "", total: 0, start: 0, display: 0, items: [])))
                .map(\.data.items)
                .eraseToAnyPublisher()
            }
            .sinkWeak(on: self) { viewModel, list in
                viewModel.triggerUpdateShoppingModels(list: list)
            }
            .store(in: &subscriptions)
        
        input.sortTypeButtonTapped
            .sinkWeakStore(
                on: self,
                in: &subscriptions
            ) { viewModel, tag in
                viewModel.triggerSelectedCategory(tag: tag)
            }
        
        input.refreshRequest
            .sinkWeakStore(
                on: self,
                in: &subscriptions
            ) { viewModel, isRefresh in
                viewModel.triggerRefresh(isRefresh: isRefresh)
            }
        
        return Output(
            isLoadingNextpage: isLoadingNextPage.eraseToAnyPublisher(),
            pagingResult: shoppingListSubject.eraseToAnyPublisher(),
            endRefresh: endRefreshSubject.eraseToAnyPublisher()
        )
    }
    
    private func triggerUpdateShoppingModels(list: [ShoppingItemDTO]) {
        let originDTO = self.shoppingListSubject.value
        let total = originDTO.list + list
        self.logger.log(level: .debug, "\(Self.self) - \(#function) receive Value shoppingList count: \(total.count)")
        self.shoppingListSubject.send(Model(list: total, priorCount: originDTO.list.count))
    }
    
    private func triggerRefresh(isRefresh: Bool) {
        logger.log(level: .info, "\(Self.self)-\(#function)- triggeredRefresh: \(String(describing: isRefresh))")
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            logger.log(level: .info, "\(Self.self)-\(#function) - !isRefresh: \(!isRefresh)")
            endRefreshSubject.send()
        }
    }
    
    private func triggerSelectedCategory(tag: Int) {
        let sortType = ShoppingSortType.matchTag(tag)
        let initialpagingState = self.paginagState.loadInitialState(sortType: sortType)
        self.paginagState = initialpagingState
        shoppingListSubject.value = .init(list: [], priorCount: 0)
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
    }
}
