//
//  TopicViewModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import CustomObservable

final class TopicViewModel {
    
    struct Input {
        var viewDidLoad: LazyObservable<Void>
        var pullToRefreshTrigger: LazyObservable<Void>
        var retrySectionTrigger: LazyObservable<Section>
    }
    
    struct Output {
        var state: EagerObservable<ViewState>
        var refreshSignal: LazyObservable<Void>
        var toastMessage: LazyObservable<String>
    }
    
    struct SectionAndItem: Hashable {
        let section: Section
        let item: [Item]
    }
    
    enum Section: Hashable, CaseIterable {
        case architectureInterior
        case goldenHour
        case wallpapers
        case nature
        case renders3d
        case travel
        case texturesPatterns
        case streetPhotography
        case film
        case archival
        case experimental
        case animals
        case fashionBeauty
        case people
        case businessWork
        case foodDrink
    }
    
    enum Item: Hashable {
        case firstItem(TopicPhotoModel?)
        case secondItem(TopicPhotoModel?)
        case thirdItem(TopicPhotoModel?)
        case retryItem(Section)
    }
    
    enum ViewState {
        case loading([SectionAndItem])
        case loaded([SectionAndItem])
        case partial([SectionAndItem], [APIError])
        case failed([SectionAndItem], [APIError])
    }
    
    private let topicProvider: TopicProvider
    private var lastRefreshDate: Date?
    private(set) var randomTrippleSection: [Section]
    
    private var retryLoadingSectionList: [SectionAndItem] {
        randomTrippleSection.map {
            SectionAndItem(
                section: $0,
                item: [.retryItem($0)]
            )
        }
    }
    
    private lazy var state = EagerObservable<ViewState>(source: .next(.loading(retryLoadingSectionList)))
    private var refreshSignal = LazyObservable<Void>()
    private var toastMessage = LazyObservable<String>()
    private var bag = Bag()
    
    init(topicProvider: TopicProvider) {
        self.topicProvider = topicProvider
        randomTrippleSection = Array(Section.allCases.shuffled().prefix(3))
    }
    
    func transform(input: Input) -> Output {
        input.pullToRefreshTrigger
            .subscribeOn { [weak self] _ in
                guard let self else { return }
                let now = Date.now
                

                if let last = self.lastRefreshDate, now.timeIntervalSince(last) < 60 {
                    let diff = 60 - round(now.timeIntervalSince(last))
                    self.refreshSignal.source(.next(()))
                    self.toastMessage.source(.next("\(Int(diff)) 초 뒤에 다시 시도해주세요!"))
                    return
                }
                
                self.randomTrippleSection = Array(Section.allCases.shuffled().prefix(3))
                self.lastRefreshDate = now
                self.topicProvider.fetchGroup(topicList: self.randomTrippleSection.map(\.topic)) { results in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.loadTopicModels(results: results)
                        self.refreshSignal.source(.next(()))
                    })
                }
            }
            .disposed(in: bag)
        
        input.viewDidLoad
            .subscribeOn { [weak self] _ in
                guard let self else { return }
                self.topicProvider.fetchGroup(topicList: self.randomTrippleSection.map(\.topic)) { results in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.loadTopicModels(results: results)
                    })
                }
            }
            .disposed(in: bag)
        
        return Output(
            state: state,
            refreshSignal: refreshSignal,
            toastMessage: toastMessage
        )
    }
    
    private func loadTopicModels(results: [Result<[TopicPhotoDTO], any Error>]) {
        let (models, error) = self.mapResult(results[0])
        var sectionItemList = [SectionAndItem]()
        var apiErrors = [APIError]()
        
        if error == nil {
            sectionItemList.append(
                SectionAndItem(
                    section: .architectureInterior,
                    item: models.map { Item.firstItem($0) }
                )
            )
        } else {
            sectionItemList.append(
                SectionAndItem(
                    section: .architectureInterior,
                    item: [.retryItem(.architectureInterior)]
                )
            )
            apiErrors.append(error!)
            
        }
        
        let (secondModels, secondError) = self.mapResult(results[1])
        if secondError == nil {
            sectionItemList.append(
                SectionAndItem(
                    section: .goldenHour,
                    item: secondModels.map { Item.firstItem($0) }
                )
            )
        } else {
            sectionItemList.append(
                SectionAndItem(
                    section: .goldenHour,
                    item: [.retryItem(.goldenHour)]
                )
            )
            apiErrors.append(.forbidden)
        }
        
        let (thirdModels, thirdError) = self.mapResult(results[2])
        if thirdError == nil {
            sectionItemList.append(
                SectionAndItem(
                    section: .businessWork,
                    item: thirdModels.map { Item.firstItem($0) }
                )
            )
        } else {
            sectionItemList.append(
                SectionAndItem(
                    section: .businessWork,
                    item: [.retryItem(.businessWork)]
                )
            )
            apiErrors.append(thirdError!)
        }
        
        if apiErrors.count == 0 {
            self.state.source = .next(.loaded(sectionItemList))
        } else if apiErrors.count == 3 {
            self.state.source = .next(.failed(sectionItemList, apiErrors))
        } else {
            self.state.source = .next(.partial(sectionItemList, apiErrors))
        }
    }
    
    private func mapResult(_ result: Result<[TopicPhotoDTO], any Error>) -> ([TopicPhotoModel], APIError?) {
        switch result {
        case .success(let success):
            return (success.map { $0.toModel() }, nil)
            
        case .failure(let error):
            return ([], APIError.map(error))
        }
    }
}

extension TopicViewModel.Section {
    var topic: Topic {
        switch self {
        case .architectureInterior: return .architecture_interior
        case .goldenHour:          return .golden_hour
        case .wallpapers:          return .wallpapers
        case .nature:              return .nature
        case .renders3d:           return .renders_3d
        case .travel:              return .travel
        case .texturesPatterns:    return .textures_patterns
        case .streetPhotography:   return .street_photography
        case .film:                return .film
        case .archival:            return .archival
        case .experimental:        return .experimental
        case .animals:             return .animals
        case .fashionBeauty:       return .fashion_beauty
        case .people:              return .people
        case .businessWork:        return .business_work
        case .foodDrink:           return .food_drink
        }
    }
    
    var title: String {
        switch self {
        case .architectureInterior: return "건축 및 인테리어"
        case .goldenHour:          return "골든 아워"
        case .wallpapers:          return "배경 화면"
        case .nature:              return "자연"
        case .renders3d:           return "3D 렌더링"
        case .travel:              return "여행하다"
        case .texturesPatterns:    return "텍스처 및 패턴"
        case .streetPhotography:   return "거리 사진"
        case .film:                return "필름"
        case .archival:            return "기록의"
        case .experimental:        return "실험적인"
        case .animals:             return "동물"
        case .fashionBeauty:       return "패션 및 뷰티"
        case .people:              return "사람"
        case .businessWork:        return "비지니스 및 업무"
        case .foodDrink:           return "식음료"
        }
    }
}
