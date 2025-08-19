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
        case header(name: String, date: String, liked: Bool)
        case photo(String)
        case infoKeyValue(key: String, value: String)
        case title(text: String)
        case segment
        case chart([DayValue])
    }
    
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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
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
    
    override func binding() {
        dataInit()
        
        viewModel.transform()
        
        viewModel.stats
            .subscribeOn { [weak self] stats in
                DispatchQueue.main.async {
                    guard let self else { return }
                    var snapShot = self.dataSource.snapshot()

                    let oldInfoItems = snapShot.itemIdentifiers(inSection: .infoRow)
                    
                    snapShot.deleteItems(oldInfoItems)
                    
                    let newInfoItems: [Item] = [
                        .infoKeyValue(key: "크기", value: "\(self.viewModel.model.width) x \(self.viewModel.model.height)"),
                        .infoKeyValue(key: "조회수", value: "\(stats.views?.total?.formatted() ?? "0")"),
                        .infoKeyValue(key: "다운로드", value: "\(stats.downloads?.total?.formatted() ?? "0")")
                    ]
                    
                    snapShot.appendItems(newInfoItems, toSection: .infoRow)

                    let oldChartHistory = snapShot.itemIdentifiers(inSection: .chart)
                    
                    snapShot.deleteItems(oldChartHistory)
                    
                    let dayValues = stats.views?.historical?.values?.map {
                        DayValue(date: $0.date?.toDate("yyyy-MM-dd") ?? Date.now, value: Double($0.value ?? 0))
                    }
                    print("dayValues: \(dayValues)")
                    if let dayValues {
                        print("dayValues: \(dayValues)")
                        snapShot.appendItems([.chart(dayValues)], toSection: .chart)
                    }
                    
                    self.dataSource.apply(snapShot, animatingDifferences: true)
                }
            }
            .disposed(in: bag)
        
        viewModel.viewDidLoad.source(.next(()))
    }
    
    private func dataInit() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        snapshot.appendItems([.header(name: "\(viewModel.model.userDTO?.username ?? "hwan")",
                                      date: "\(viewModel.model.createdAt ?? "ㅜ")일 게시됨",
                                      liked: false)], toSection: .header)
        
        snapshot.appendItems([.photo(viewModel.model.regularURL)], toSection: .photo)
        snapshot.appendItems([.title(text: "정보")], toSection: .infoTitle)
        
        snapshot.appendItems([
            .infoKeyValue(key: "크기", value: "\(viewModel.model.width) x \(viewModel.model.height)"),
            .infoKeyValue(key: "조회수", value: "1,548,623"),
            .infoKeyValue(key: "다운로드", value: "388,996")
        ], toSection: .infoRow)
        
        snapshot.appendItems([.title(text: "차트")], toSection: .chartTitle)
        snapshot.appendItems([.segment], toSection: .chartSegment)
        snapshot.appendItems([.chart([])], toSection: .chart)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: - Diffable DataSource
private extension SearchDetailViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case let .header(name, date, liked):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCell.id, for: indexPath) as! HeaderCell
                cell.set(name: name, date: date, liked: liked)
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
                cell.set(items: ["조회", "다운로드"], selectedIndex: 0)
                return cell
                
            case let .chart(dayValues):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartCell.id, for: indexPath) as! ChartCell
                cell.set(with: dayValues)
                return cell
            }
        }
    }
}

private final class HeaderCell: BaseCollectionViewCell, CellIdentifialble {
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    
    override func addAttributes() {
        avatarView.backgroundColor = .secondarySystemBackground
        avatarView.layer.cornerRadius = 16
        avatarView.clipsToBounds = true
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = .preferredFont(forTextStyle: .caption2)
        dateLabel.textColor = .secondaryLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .systemBlue
        likeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addChild() {
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 32),
            avatarView.heightAnchor.constraint(equalToConstant: 32),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: 8)
        ])
    }
    
    func set(name: String, date: String, liked: Bool) {
        nameLabel.text = name
        dateLabel.text = date
        likeButton.isSelected = liked
    }
}

// MARK: - Compositional Layout
extension SearchDetailViewController {
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
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
                
            case .infoTitle:
                fallthrough
                
            case .chartTitle:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)))
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
