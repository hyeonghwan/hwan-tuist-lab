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
    struct ViewState {
        var state: [SectionAndItem] = []
    }
    
    struct SectionAndItem: Hashable {
        let section: Section
        let item: [Item]
    }
    
    enum Section: Int, CaseIterable {
        case header
        case photo
        case infoTitle
        case infoRow
        case chartTitle
        case chartSegment
        case chart
    }
    
    enum Item: Hashable {
        case header(profileURL: String, name: String, date: String, liked: Bool)
        case photo(String)
        case infoKeyValue(key: String, value: String)
        case title(text: String)
        case segment
        case chart(views: [DayValue], downloads: [DayValue], segment: SegmentItem)
    }
    
    struct Input {
        var viewDidLoad: LazyObservable<Void>
        var changeGraphTrigger: LazyObservable<String>
        var heartButtonTapped: LazyObservable<Bool>
        var chartSegmentInfoTrigger: LazyObservable<SegmentItem>
    }
    
    struct Output {
        var status: EagerObservable<ViewState>
        var reloadSection: EagerObservable<[SectionAndItem]>
        let errorHandle: LazyObservable<APIError>
    }
    
    private let provider: PhotoStatProvider
    private let favoriteStore: FavoriteStore
    private var bag = Bag()
    private(set) var model: PhotoModel
    
    // MARK: Output
    private var reloadSection = EagerObservable<[SectionAndItem]>(source: .next([]))
    private var errorHandle = LazyObservable<APIError>()
    
    private var segmentDebouncer = Debouncer(delay: 0.4)
    private var favoriteDebouncer = Debouncer(delay: 0.4)
    
    private lazy var status = EagerObservable<ViewState>(
        source: .next(
            ViewState(
                state: [
                    SectionAndItem(
                        section: .header,
                        item: [.header(
                            profileURL: model.userDTO?.profileImage?.medium ?? "",
                            name: "\(model.userDTO?.username ?? "hwan")",
                            date: "\(model.createdAt ?? "N/A") 일 게시됨",
                            liked: model.userLike
                        )]
                    ),
                    SectionAndItem(
                        section: .photo,
                        item: [.photo(model.regularURL)]
                    ),
                    SectionAndItem(
                        section: .infoTitle,
                        item: [.title(text: "정보")]
                    ),
                    SectionAndItem(
                        section: .infoRow,
                        item: [
                            .infoKeyValue(key: "크기", value: "\(model.width) x \(model.height)"),
                            .infoKeyValue(key: "조회수", value: "0"),
                            .infoKeyValue(key: "다운로드", value: "0")
                        ]
                    ),
                    SectionAndItem(
                        section: .chartTitle,
                        item: [.title(text: "차트")]
                    ),
                    SectionAndItem(
                        section: .chartSegment,
                        item: [.segment]
                    ),
                    SectionAndItem(
                        section: .chart,
                        item: []
                    )
                ]
            )
        )
    )
    
    init(favoriteStore: FavoriteStore, provider: PhotoStatProvider, model: PhotoModel) {
        self.favoriteStore = favoriteStore
        self.provider = provider
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoad.subscribeAsync { [weak self] _ in
            guard let self else { return }
            let result = await self.provider.getStats(id: self.model.id)
            switch result {
            case let .success(dto):
                let sectionAndItems = self.mapToSectionItem(statsDTO: dto)
                self.reloadSection.source = .next(sectionAndItems)
                
            case let .failure(error):
                let apiError = APIError.map(error)
                self.errorHandle.source(.next(apiError))
            }
        }
        .disposed(in: bag)
        
        input.heartButtonTapped
            .subscribeOn { [weak self] isFavorite in
                guard let self else { return }
                if isFavorite {
                    self.model.userLike = true
                    self.favoriteStore.set(self.model)
                } else {
                    self.model.userLike = false
                    self.favoriteStore.remove(id: self.model.id)
                }
            }
            .disposed(in: bag)
        
        input.chartSegmentInfoTrigger
            .subscribeOn { [weak self] segmentType in
                guard let self else { return }
                self.segmentDebouncer.run {
                    self.chartTypeChangeReload(segmentType: segmentType)
                }
            }
            .disposed(in: bag)
        
        return Output(
            status: self.status,
            reloadSection: self.reloadSection,
            errorHandle: self.errorHandle
        )
    }
    
    private func chartTypeChangeReload(segmentType: SegmentItem) {
        guard let sectionAndItem = self.reloadSection.value.last, let item = sectionAndItem.item.last else { return }
        if case let .chart(views: viewsDays, downloads: downloadsDays, segment: _) = item {
            self.reloadSection.source = .next([
                .init(
                    section: .chart,
                    item: [
                        Item.chart(
                            views: viewsDays,
                            downloads: downloadsDays,
                            segment: segmentType
                        )
                    ]
                )
            ])
        }
    }
    
    private func mapToSectionItem(statsDTO: StatsResponseDTO) -> [SectionAndItem] {
        let newInfoItems: [Item] = [
            .infoKeyValue(key: "크기", value: "\(self.model.width) x \(self.model.height)"),
            .infoKeyValue(key: "조회수", value: "\(statsDTO.views?.total?.formatted() ?? "0")"),
            .infoKeyValue(key: "다운로드", value: "\(statsDTO.downloads?.total?.formatted() ?? "0")")
        ]
        
        let (viewsDays, downloadDays) = self.dateMapping(stats: statsDTO)
        
        let infoRowSectionItem = SectionAndItem(section: .infoRow, item: newInfoItems)
        let chartSectionItem = SectionAndItem(
            section: .chart,
            item: [
                .chart(
                    views: viewsDays,
                    downloads: downloadDays,
                    segment: .viewer
                )
            ]
        )
        
        return [infoRowSectionItem, chartSectionItem]
    }
    
    private func dateMapping(stats: StatsResponseDTO) -> (views: [DayValue], downloads: [DayValue]) {
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date.now)
        
        var last30DaysOfViews = (0..<30).map { offset -> DayValue in
            let date = calendar.date(byAdding: .day, value: -(29 - offset), to: today)!
            return DayValue(date: date, value: 0)
        }
        
        var last30DaysOfDownloads = last30DaysOfViews
        
        if let values = stats.views?.historical?.values {
            for (i, value) in values.enumerated() {
                if let dateString = value.date, let date = dateString.toDate("yyyy-MM-dd") {
                    last30DaysOfViews[i] = DayValue(date: date, value: Double(value.value ?? 0))
                }
            }
        }
        
        if let values = stats.downloads?.historical?.values {
            for (i, value) in values.enumerated() {
                if let dateString = value.date, let date = dateString.toDate("yyyy-MM-dd") {
                    last30DaysOfDownloads[i] = DayValue(date: date, value: Double(value.value ?? 0))
                }
            }
        }
        
        return (last30DaysOfViews, last30DaysOfDownloads)
    }
}
