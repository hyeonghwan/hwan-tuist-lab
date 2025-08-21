//
//  SearchDetailViewController.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import CustomObservable

final class SearchDetailViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.register(HeaderCell.self, forCellWithReuseIdentifier: HeaderCell.id)
        collectionView.register(PhotoImageCell.self, forCellWithReuseIdentifier: PhotoImageCell.id)
        collectionView.register(KeyValueCell.self, forCellWithReuseIdentifier: KeyValueCell.id)
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: TitleCell.id)
        collectionView.register(SegmentCell.self, forCellWithReuseIdentifier: SegmentCell.id)
        collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ChartCell.id)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<SearchDetailViewModel.Section, SearchDetailViewModel.Item>!
    
    static func create(with dependency: SearchDetailViewModel) -> SearchDetailViewController {
        let vc = SearchDetailViewController()
        vc.viewModel = dependency
        return vc
    }
    
    var viewModel: SearchDetailViewModel!
    private var bag = Bag()
    
    override func addAttributes() {
        view.backgroundColor = .systemBackground
        configureDataSource()
    }
    
    override func addChild() {
        view.addSubview(collectionView)
    }
    
    override func addLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private let viewDidLoad = LazyObservable<Void>()
    private let changeGraphTrigger = LazyObservable<String>()
    private let heartButtonTapped = LazyObservable<Bool>()
    private let chartSegmentInfoTrigger = LazyObservable<SegmentItem>()
    
    
    override func binding() {
        var snapShot = self.dataSource.snapshot()
        snapShot.appendSections(SearchDetailViewModel.Section.allCases)
        self.dataSource.apply(snapShot)
        
        let output = viewModel.transform(
            input: SearchDetailViewModel.Input(
                viewDidLoad: viewDidLoad,
                changeGraphTrigger: changeGraphTrigger,
                heartButtonTapped: heartButtonTapped,
                chartSegmentInfoTrigger: chartSegmentInfoTrigger
            )
        )
        
        output.errorHandle
            .subscribeOn { [weak self] apiError in
                DispatchQueue.main.async {
                    self?.showToastMessage(offsetY: UIScreen.main.bounds.height - 150, message: apiError.message)
                }
            }
            .disposed(in: bag)
        
        output.status
            .subscribeOn { [weak self] viewState in
                DispatchQueue.main.async {
                    guard let self else { return }
                    var currentSnapShot = self.dataSource.snapshot()
                    for state in viewState.state {
                        currentSnapShot.appendItems(
                            state.item,
                            toSection: state.section
                        )
                    }
                    self.dataSource.apply(currentSnapShot)
                }
            }
            .disposed(in: bag)
        
        output.reloadSection
            .subscribeOn { [weak self] sectionAndItems in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.reloadSection(sectionAndItems: sectionAndItems)
                }
            }
            .disposed(in: bag)
        
        viewDidLoad.source(.next(()))
    }
    
    private func reloadSection(sectionAndItems: [SearchDetailViewModel.SectionAndItem]) {
        var snapShot = self.dataSource.snapshot()
        for sectionAndItem in sectionAndItems {
            let section = sectionAndItem.section
            let items = sectionAndItem.item
            let oldItems = snapShot.itemIdentifiers(inSection: section)
            snapShot.deleteItems(oldItems)
            snapShot.appendItems(items, toSection: section)
        }
        self.dataSource.apply(snapShot)
    }
}


private extension SearchDetailViewController {
    
    @objc
    func chartSegmentInfoTapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.chartSegmentInfoTrigger.source(.next(index == 0 ? .viewer : .download))
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton) {
        let origin = sender.isSelected
        sender.isSelected = !origin
        
        var snapshot = dataSource.snapshot()
        
        if let oldHeader = snapshot.itemIdentifiers(inSection: .header).first,
           case let .header(profileURL: url, name: name, date: date, liked: _) = oldHeader {
            let newHeader: SearchDetailViewModel.Item = .header(profileURL: url, name: name, date: date, liked: !origin)
            snapshot.deleteItems([oldHeader])
            snapshot.appendItems([newHeader], toSection: .header)
            dataSource.apply(snapshot, animatingDifferences: false)
        }
        
        heartButtonTapped.source(.next(!origin))
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchDetailViewModel.Section, SearchDetailViewModel.Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            
            switch item {
            case let .header(profileURL, name, date, liked):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.id, for: indexPath) as! HeaderCell
                cell.set(profileURL: profileURL, name: name, date: date, liked: liked)
                if let self {
                    cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
                }
                return cell
                
            case let .photo(item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoImageCell.id, for: indexPath) as! PhotoImageCell
                cell.setImage(urlString: item)
                return cell
                
            case let .infoKeyValue(key, value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyValueCell.id, for: indexPath) as! KeyValueCell
                cell.set(key: key, value: value)
                return cell
                
            case let .title(text):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.id, for: indexPath) as! TitleCell
                cell.set(text: text)
                return cell
                
            case .segment:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SegmentCell.id, for: indexPath) as! SegmentCell
                if let self {
                    cell.segment.addTarget(self, action: #selector(chartSegmentInfoTapped(_:)), for: .valueChanged)
                }
                return cell
                
            case let .chart(views, downloads, mode):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.id, for: indexPath) as! ChartCell
                if mode == .viewer {
                    cell.set(with: views)
                } else if mode == .download {
                    cell.set(with: downloads)
                }
                return cell
            }
        }
    }
}

// MARK: Compositional Layout
extension SearchDetailViewController {
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let section = SearchDetailViewModel.Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .header:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(52)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(52)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 8, leading: 16, bottom: 4, trailing: 16)
                return section
                
            case .photo:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
                let group = NSCollectionLayoutGroup
                    .vertical(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(self?.viewModel.model.ratio ?? 0.6)),
                        subitems: [item]
                    )
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case .infoTitle, .chartTitle:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(32)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 16, leading: 16, bottom: 8, trailing: 16)
                return section
                
            case .infoRow:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(22)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(72)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                section.interGroupSpacing = 8
                return section
                
            case .chartSegment:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(36)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(36)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 8, trailing: 16)
                return section
                
            case .chart:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 16, bottom: 40, trailing: 16)
                return section
            }
        }
        return layout
    }
}
