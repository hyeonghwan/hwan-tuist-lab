//
//  ShoppingResultViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
 
import Combine
import Kingfisher

  
final class ShoppingResultViewController: BaseViewController {
    
    // MARK: View
    private let headerView = ShoppingHeaderView()
    private let collectionView = ShoppingCollectionView()
    private let indicatorContainerView = IndicatorContainerView()
    
    // MARK: Presenter
    private let scrollAnimator = ScrollAnimator()
    private lazy var pagenationController = PagenationController(
        scrollView: collectionView,
        shoppingPagingSubject: shoppingPagingSubject
    )
    
    // MARK: ViewModel
    var shoppingViewModel: ShoppingViewModel!
    
    // MARK: Datasource
    private lazy var shoppingDataSource = ShoppingCollectionViewDataSource(
        viewModel: shoppingViewModel
    )
    
    // MARK: ViewModel Input
    private let shoppingPagingSubject = PassthroughSubject<Void, Never>()
    private let refreshingSubject = PassthroughSubject<Void, Never>()
    private var retryLoadSubject = PassthroughSubject<ShoppingSortType, Never>()
    
    // MARK: Subscriptions
    private(set) var subscriptions = Set<AnyCancellable>()
    
    deinit {
        KingfisherManager.shared.cache.clearCache()
    }
    
    override func addChild() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(indicatorContainerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        KingfisherManager.shared.cache.clearMemoryCache()
    }
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .green
        collectionView.refreshControl = refreshControl
        
        navigationSetting()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = shoppingDataSource
        scrollAnimator.delegate = view
        
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        indicatorContainerView.isHidden = true
    }
    
    override func addLayout() {
        scrollAnimator.headerViewTopAnchor = headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        scrollAnimator.headerViewTopAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            indicatorContainerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            indicatorContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            indicatorContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            indicatorContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(indicatorContainerView)
        
        let headerHeight = headerView.bounds.height
        collectionView.contentInset.top = headerHeight
        collectionView.verticalScrollIndicatorInsets.top = headerHeight
    }
    
    override func binding() {
        let refreshInput = collectionView
            .refreshControl!
            .refreshPublisher
            .compactMap { [weak self] value -> ShoppingSortType? in
                guard let self else { return nil }
                return ShoppingSortType.matchTag(self.headerView.selectedIndex)
            }
        
        let output = shoppingViewModel.transform(
            ShoppingViewModel.Input(
                viewDidLoad: self.viewDidLoadPublisher.map { _ in ShoppingSortType.sim }.eraseToAnyPublisher(),
                pagingRequest: shoppingPagingSubject.eraseToAnyPublisher(),
                sortTypeButtonTapped: headerView.selectedIndexPublisher,
                refreshRequest: refreshInput.eraseToAnyPublisher(),
                retryLoadSubject: retryLoadSubject.eraseToAnyPublisher()
            )
        )
        
        self.pagenationController.observe(output.guardPaging)
        
        output.isLoadingCell
            .sinkWeak(on: self) { vc, value in
                vc.indicatorContainerView.isHidden = !value
                if value {
                    vc.indicatorContainerView.indicator.startAnimating()
                } else {
                    vc.indicatorContainerView.indicator.stopAnimating()
                }
            }
            .store(in: &subscriptions)
        
        output.refreshSignal
            .sinkWeak(on: self) { vc, _ in
                vc.collectionView.reloadData()
                DispatchQueue.main.async {
                    vc.shoppingViewModel.guardPaging.send(false)
                    vc.shoppingViewModel.isLoadingCell.send(false)
                    if vc.collectionView.refreshControl!.isRefreshing == true {
                        vc.collectionView.refreshControl!.endRefreshing()
                        let x = vc.collectionView.contentOffset.x
                        let y = -vc.headerView.bounds.height
                        vc.collectionView.setContentOffset(CGPoint(x: x, y: y), animated: true)
                    }
                }
            }
            .store(in: &subscriptions)
        
        output.loadModelSignal
            .sinkWeak(on: self) { vc, _ in
                vc.collectionView.reloadData()
                DispatchQueue.main.async {
                    vc.shoppingViewModel.guardPaging.send(false)
                    vc.shoppingViewModel.isLoadingCell.send(false)
                }
            }
            .store(in: &subscriptions)
        
        output.pagingSignal
            .receive(on: DispatchQueue.main)
            .sinkWeak(on: self) { vc, _ in
                vc.collectionView.reloadData()
                DispatchQueue.main.async {
                    vc.shoppingViewModel.guardPaging.send(false)
                    vc.shoppingViewModel.isLoadingPagingIndicator.send(false)
                }
            }
            .store(in: &subscriptions)
        
        output.totalCount
            .map { "\(String(describing: $0.formattedNumber() ?? "")) 개" }
            .sinkWeak(on: self) { vc, string in
                vc.headerView.label.text = string
            }
            .store(in: &subscriptions)
        
        output.dataLoadFailed
            .sinkWeak(on: self) { vc, error in
                vc.showFallBackAlert(error)
                DispatchQueue.main.async {
                    vc.shoppingViewModel.guardPaging.send(false)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func navigationSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = self.view.backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonDisplayMode = .minimal
    }
}

// MARK: UICollectionViewDelegate
extension ShoppingResultViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollAnimator.showOrHideHeaderAction(scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if shoppingViewModel.shoppingListSubject.value.list.count >= 1 {
            return CGSize(
                width: (windowWidth / 2) - 16,
                height: 270
            )
        } else {
            return CGSize(
                width: windowWidth,
                height: 50
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: windowWidth, height: 100)
    }
}


// MARK: PagenationController
extension ShoppingResultViewController {
      
    fileprivate class PagenationController {
        private weak var scrollView: UIScrollView!
        private weak var shoppingPagingSubject: PassthroughSubject<(Void), Never>?
        private var cancellable: AnyCancellable?
        
        init(scrollView: UIScrollView, shoppingPagingSubject: PassthroughSubject<Void, Never>) {
            self.shoppingPagingSubject = shoppingPagingSubject
            self.scrollView = scrollView
        }
        
        func observe(_ isApiLoading: AnyPublisher<Bool, Never>) {
            guard let scrollView = self.scrollView else { return }
            cancellable = scrollView.publisher(for: \.contentOffset)
                .removeDuplicates(by: { $0.y == $1.y })
                .combineLatest(isApiLoading)
                .filter { (_, isLoading) in
                    return !isLoading
                }
                .throttle(for: .milliseconds(600), scheduler: DispatchQueue.main, latest: true)
                .filter { [weak self] _ in
                    (self?.scrollView?.contentSize.height ?? 0) > 0
                }
                .sinkWeak(on: self) { (controller, _) in
                    guard let scrollView = controller.scrollView else { return }
                    let offsetY = scrollView.contentOffset.y
                    let contentHeight = scrollView.contentSize.height
                    let boundsHeight = scrollView.bounds.height
                    let totalOffset = offsetY + boundsHeight
                    if totalOffset > (contentHeight * 3) / 4 {
                        controller.shoppingPagingSubject?.send()
                    }
                }
        }
    }
}

// MARK: ScrollAnimator
extension ShoppingResultViewController {
      
    fileprivate class ScrollAnimator: NSObject {
        weak var delegate: UIView?
        var headerViewTopAnchor: NSLayoutConstraint!
        
        private var beforeContentOffsetY: CGFloat = 0
        private var accDeltaY: CGFloat = 0
        private var isHeaderHidden: Bool = false
    
        private func hideHeader() {
            isHeaderHidden = true
            headerViewTopAnchor.constant = -80
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.delegate?.layoutIfNeeded()
            }
        }

        private func showHeader() {
            isHeaderHidden = false
            headerViewTopAnchor.constant = 0
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.delegate?.layoutIfNeeded()
            }
        }
        
        func showOrHideHeaderAction(scrollView: UIScrollView) {
            let contentOffsetY = scrollView.contentOffset.y
            let isTop = contentOffsetY < 0
            let isBottom = contentOffsetY + scrollView.bounds.height > scrollView.contentSize.height + 10
            
            if isTop || isBottom {
                return
            }
            
            let deltaY = contentOffsetY - beforeContentOffsetY
            if (deltaY > 0 && accDeltaY < 0) || (deltaY < 0 && accDeltaY > 0) {
                accDeltaY = 0
            }
            
            accDeltaY += deltaY
            beforeContentOffsetY = contentOffsetY

            if accDeltaY > 50 && !isHeaderHidden {
                hideHeader()
            } else if accDeltaY < -50 && isHeaderHidden {
                showHeader()
            }
        }
    }
}
