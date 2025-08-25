//
//  TopicViewController.swift
//  PhotoFeature
//
//  Created by hwan on 8/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import CustomObservable

final class TopicViewController: BaseViewController {
    
    static func create(with topicViewModel: TopicViewModel) -> TopicViewController {
        let vc = TopicViewController()
        vc.viewModel = topicViewModel
        return vc
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<TopicViewModel.Section, TopicViewModel.Item>!
    private lazy var topicCollectionView = TopicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private var viewModel: TopicViewModel!
    
    private let viewDidLoad = LazyObservable<Void>()
    private let pullToRefreshTrigger = LazyObservable<Void>()
    private let retrySectionTrigger = LazyObservable<TopicViewModel.Section>()
    private var bag = Bag()
    
    override func addAttributes() {
        self.view.backgroundColor = .white
        
        configureDataSource()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        topicCollectionView.refreshControl = refreshControl
        topicCollectionView.refreshControl!.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)
        
        topicCollectionView.dataSource = dataSource
    }
    
    override func addChild() {
        self.view.addSubview(topicCollectionView)
        topicCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func handleRefreshControl(_ sender: UIRefreshControl) {
        self.pullToRefreshTrigger.source(.next(()))
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            topicCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topicCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topicCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topicCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func binding() {
        let output = viewModel.transform(
            input: .init(
                viewDidLoad: viewDidLoad,
                pullToRefreshTrigger: pullToRefreshTrigger,
                retrySectionTrigger: retrySectionTrigger
            )
        )
        
        output.refreshSignal
            .subscribeOn { [weak self] in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if let control = self.topicCollectionView.refreshControl,
                       control.isRefreshing {
                        self.topicCollectionView.refreshControl?.endRefreshing()
                    }
                }
            }
            .disposed(in: bag)
        
        output.state
            .subscribeOn { [weak self] state in
                guard let self else { return }
                switch state {
                case .loading:
                    var snapshot = NSDiffableDataSourceSnapshot<TopicViewModel.Section, TopicViewModel.Item>()
                    snapshot.appendSections(self.viewModel.randomTrippleSection)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                    
                case let .loaded(sectionItemList):
                    var snapshot = NSDiffableDataSourceSnapshot<TopicViewModel.Section, TopicViewModel.Item>()
                    snapshot.appendSections(self.viewModel.randomTrippleSection)
                    snapshot.appendItems(sectionItemList[0].item, toSection: self.viewModel.randomTrippleSection[0])
                    snapshot.appendItems(sectionItemList[1].item, toSection: self.viewModel.randomTrippleSection[1])
                    snapshot.appendItems(sectionItemList[2].item, toSection: self.viewModel.randomTrippleSection[2])
                    dataSource.apply(snapshot, animatingDifferences: true)
                
                case let .partial(sectionItemList, apiErrors):
                    self.loadApply(sectionItemList, apiErrors)
                    
                case let .failed(sectionItemList, apiErrors):
                    self.loadApply(sectionItemList, apiErrors)
                }
            }
            .disposed(in: bag)
        
        output.toastMessage
            .subscribeOn { [weak self] message in
                DispatchQueue.main.async {
                    self?.showToastMessage(
                        offsetY: UIScreen.main.bounds.height - 150,
                        status: .check,
                        message: message
                    )
                }
            }
            .disposed(in: bag)
        
        viewDidLoad.source(.next(()))
    }
    
    private func loadApply(_ sectionItemList: [TopicViewModel.SectionAndItem], _ apiErrors: [APIError]) {
        var snapShot = self.dataSource.snapshot()
        for sectionItem in sectionItemList {
            let section = sectionItem.section
            
            let hasRetry = sectionItem.item.contains {
                if case .retryItem = $0 { return true }
                return false
            }
            
            let existingItems = snapShot.itemIdentifiers(inSection: section)
            let isEmpty = existingItems.isEmpty

            guard hasRetry || isEmpty else { continue }
            
            if !snapShot.sectionIdentifiers.contains(section) {
                snapShot.appendSections([section])
            }
            
            let existing = snapShot.itemIdentifiers(inSection: section)
            
            if !existing.isEmpty {
                snapShot.deleteItems(existing)
            }
            snapShot.appendItems(sectionItem.item, toSection: section)
        }
        
        self.dataSource.apply(snapShot, animatingDifferences: true)
        
        self.showToastMessage(offsetY: UIScreen.main.bounds.height - 150, message: apiErrors.map(\.message).joined(separator: "\n"))
    }
}

extension TopicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .retryItem(let section):
            retrySectionTrigger.source(.next(section))
        default:
            break
        }
    }
}

extension TopicViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TopicViewModel.Section, TopicViewModel.Item>(collectionView: topicCollectionView)
        { collectionView, indexPath, item in
            switch item {
            case let .firstItem(model), let .secondItem(model), let .thirdItem(model):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicImageCell.id, for: indexPath) as! TopicImageCell
                cell.setImage(model: model)
                return cell
                
            case let .retryItem:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RetryCell.id, for: indexPath) as! RetryCell
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider
        =
        { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleSectionHeader.id,
                for: indexPath
            ) as! TitleSectionHeader
            
            let section = self.viewModel.randomTrippleSection[indexPath.section]
            header.set(text: section.title)
            return header
        }
    }
}
