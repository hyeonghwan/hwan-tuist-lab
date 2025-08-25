//
//  SearchViewController.swift
//  PhotoFeature
//
//  Created by hwan on 8/15/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Design
import UIKit
import CustomObservable
import HwanMacros

final class SearchViewController: BaseViewController {
    
    static func create(with dependency: SearchViewModel) -> SearchViewController {
        let vc = SearchViewController()
        vc.viewModel = dependency
        return vc
    }
    
    
    private let tagDataSource = TagSegmentCollectionView.DataSource()
    private lazy var tagDelegate = TagSegmentCollectionView.TagDelegate(selectedTrigger: self.selectedTrigger)
    private lazy var tagSegmentCollectionView = TagSegmentCollectionView(tagDataSource, tagDelegate)
    
    private let filterButton = FilterButton()
    private let searchInfoView = SearchInfoView()
    
    private lazy var photoCollectionView: PinterestPhotoCollectionView = {
        let layout = PinterestLayout()
        layout.delegate = self
        let collectionView = PinterestPhotoCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pagenationController = PagenationController(
        scrollView: self.photoCollectionView,
        viewController: self,
        viewModel: self.viewModel
    )
    
    private var imageRatioCache: [String: Double] = [:]
    private var viewModel: SearchViewModel!
    
    private var selectedTrigger = LazyObservable<TagModel?>()
    private let selectedFilterTrigger = LazyObservable<String>()
    private let sendQueryTrigger = LazyObservable<String>()
    private let pagingTrigger = LazyObservable<Void>()
    private let reloadFinish = LazyObservable<Void>()
    private let filterButtonTrigger = EagerObservable<String>(source: .next(FilterButton.SortType.relevant.rawValue))
    private let favoriteButtonTrigger = LazyObservable<(path: IndexPath, isFavorite: Bool)>()
    
    private var bag = Bag()
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        self.filterButton.addTarget(self, action: #selector(filterButtonValueChanged(_:)), for: .valueChanged)
        searchBarSetting()
        photoCollectionView.keyboardDismissMode = .onDrag
    }
    
    @objc
    private func filterButtonValueChanged(_ sender: UIButton) {
        if let sender = sender as? FilterButton {
            self.filterButtonTrigger.source = .next(sender.currentType.rawValue)
        }
    }
    
    override func addChild() {
        self.view.addSubview(tagSegmentCollectionView)
        self.view.addSubview(filterButton)
        self.view.addSubview(photoCollectionView)
        self.view.addSubview(searchInfoView)
        
        tagSegmentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        searchInfoView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            tagSegmentCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tagSegmentCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tagSegmentCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -92),
            tagSegmentCollectionView.heightAnchor.constraint(equalToConstant: 28),
            
            filterButton.centerYAnchor.constraint(equalTo: tagSegmentCollectionView.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            filterButton.heightAnchor.constraint(equalToConstant: 28),
            filterButton.widthAnchor.constraint(equalToConstant: 80),
            
            photoCollectionView.topAnchor.constraint(equalTo: tagSegmentCollectionView.bottomAnchor, constant: 4),
            photoCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            searchInfoView.topAnchor.constraint(equalTo: self.tagSegmentCollectionView.bottomAnchor),
            searchInfoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchInfoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            searchInfoView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func binding() {
        let output = viewModel.transform(
            input: .init(
                selectedTagTrigger: selectedTrigger,
                selectedFilterTrigger: selectedFilterTrigger,
                sendQueryTrigger: sendQueryTrigger,
                pagingTrigger: pagingTrigger,
                reloadFinishTrigger: reloadFinish,
                filterButtonTrigger: filterButtonTrigger,
                favoriteButtonTrigger: favoriteButtonTrigger
            )
        )
        
        output.errorHandle
            .subscribeOn { [weak self] error in
                DispatchQueue.main.async {
                    LoadingIndicator.shared.dismiss()
                    self?.reloadFinish.source(.next(()))
                    self?.viewModel.isLoadingPagingIndicator.source = .next(false)
                    self?.showToastMessage(offsetY: UIScreen.main.bounds.height - 150, message: error.message)
                }
            }
            .disposed(in: bag)
        
        output.viewState
            .subscribeOn { [weak self] viewState in
                DispatchQueue.main.async {
                    if let selectedModel = viewState.selectedTag {
                        self?.tagDataSource.models = (self?.tagDataSource.models.map { model in
                            return if model.color == selectedModel.color {
                                TagModel(color: selectedModel.color, isSelected: true)
                            } else {
                                TagModel(color: model.color, isSelected: false)
                            }
                        }) ?? []
                        self?.tagSegmentCollectionView.reloadData()
                    }
                }
            }
            .disposed(in: bag)
        
        output.photoResultState
            .subscribeOn { [weak self] photoModels in
                DispatchQueue.main.async {
                    if photoModels.model.isEmpty {
                        self?.photoCollectionView.reloadData()
                        DispatchQueue.main.async {
                            if let self {
                                LoadingIndicator.shared.dismiss()
                                self.viewModel.isLoadingPagingIndicator.source = .next(false)
                                let text = self.navigationItem.searchController?.searchBar.text ?? ""
                                self.searchInfoView.setText(mode: text.isEmpty ? .info : .empty)
                                self.searchInfoView.isHidden = false
                            }
                        }
                        return
                    }
                    
                    if photoModels.isUpdate {
                        self?.searchInfoView.isHidden = true
                        
                        for model in photoModels.model {
                            self?.imageRatioCache[model.id] = model.ratio
                        }
                        self?.photoCollectionView.reloadData()
                        
                        DispatchQueue.main.async {
                            LoadingIndicator.shared.dismiss()
                            self?.reloadFinish.source(.next(()))
                        }
                    }
                }
            }
            .disposed(in: bag)
        
        pagenationController.observe()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoModel = self.viewModel.photoResultState.value.0[indexPath.row]
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            
            let apiClient = sceneDelegate.defaultAPIClient
            
            let vc = SearchDetailViewController.create(
                with: .init(
                    favoriteStore: sceneDelegate.favoriteStore,
                    provider: PhotoStatProvider(apiClient),
                    model: photoModel
                )
            )
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.navigationBar.tintColor = .black
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RefreshFotterView.id,
                for: indexPath) as! RefreshFotterView
            
            viewModel.isLoadingPagingIndicator
                .subscribeOn { [weak footer] isLoading in
                    DispatchQueue.main.async {
                        if isLoading {
                            footer?.refreshIndicator.startAnimating()
                        } else {
                            footer?.refreshIndicator.stopAnimating()
                        }
                    }
                }
                .disposed(in: footer.bag)
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photoResultState.value.0.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        
        let value = self.viewModel.photoResultState.value
        cell.configure(photoModel: value.0[indexPath.row])
        cell.action = { [weak self] isFavorite in
            guard let self else { return }
            self.favoriteButtonTrigger.source(.next((indexPath, isFavorite)))
        }
        
        return cell
    }
}

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let numberOfColumns: CGFloat = 2
        let cellPadding: CGFloat = 5

        let contentWidth = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        
        let columnWidth = contentWidth / numberOfColumns

        let imageWidth = columnWidth - cellPadding * 2

        let item = viewModel.photoResultState.value.0[indexPath.item]
        let ratio = CGFloat(imageRatioCache[item.id] ?? 1.2)
        
        let imageHeight = imageWidth * ratio
        
        return ceil(imageHeight + cellPadding * 2)
    }
}

import Combine

extension SearchViewController {
    fileprivate class PagenationController {
        private weak var scrollView: UIScrollView!
        private weak var viewModel: SearchViewModel?
        private weak var viewController: SearchViewController?
        private var cancellable: AnyCancellable?
        
        init(
            scrollView: UIScrollView,
            viewController: SearchViewController,
            viewModel: SearchViewModel
        ) {
            self.viewModel = viewModel
            self.viewController = viewController
            self.scrollView = scrollView
        }
        
        func observe() {
            guard let scrollView = self.scrollView else { return }
            cancellable = scrollView.publisher(for: \.contentOffset)
                .removeDuplicates(by: { $0.y == $1.y })
                .filter { [weak self] value in
                    return if let source = self?.viewModel?.viewState.value.loading {
                        !source
                    } else {
                        false
                    }
                }
                .throttle(for: .milliseconds(600), scheduler: DispatchQueue.main, latest: true)
                .filter { [weak self] _ in
                    (self?.scrollView?.contentSize.height ?? 0) > 0
                }
                .sink { [weak self] _ in
                    guard let scrollView = self?.scrollView else { return }
                    let current = scrollView.bounds.height + scrollView.contentOffset.y
                    let limit = (scrollView.contentSize.height * 9) / 10
                    if current > limit {
                        self?.viewController?.pagingTrigger.source(.next(()))
                    }
                }
        }
    }
}

// MARK: Search Setting
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    private func searchBarSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "키워드 검색",
            attributes: attributes
        )
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .label
        self.navigationItem.title = "SEARCH PHOTO"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.photoCollectionView.setContentOffset(.zero, animated: true)
            LoadingIndicator.shared.show()
            self.sendQueryTrigger.source(.next(text))
        }
    }
}
