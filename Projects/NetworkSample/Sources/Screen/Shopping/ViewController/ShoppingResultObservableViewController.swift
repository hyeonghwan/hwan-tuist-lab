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
  
final class ShoppingResultObservableViewController: BaseViewController {
    
    // MARK: View
    private let headerView = ShoppingHeaderView()
    private let collectionView = ShoppingCollectionView()
    
    private let recommededDelegate = RecommendedDelegate()
    private let recommededDataSource = RecommendedDataSource()
    private lazy var recommendedCollectionView = ShoppingRecommendedCollectionView(delegate: recommededDelegate,
                                                                                   dataSource: recommededDataSource)
    private let indicatorContainerView = IndicatorContainerView()
    
    // MARK: Presenter
    private let scrollAnimator = ScrollAnimator()
    private lazy var pagenationController = PagenationController(scrollView: collectionView,
                                                                 viewModel: self.shoppingViewModel)
    
    // MARK: ViewModel
    var shoppingViewModel: ShoppingObservableViewModel!
    private let nwTracker = NWTracker()
    
    private var bag = Bag()
    
    // MARK: Datasource
    private lazy var shoppingDataSource = ShoppingCollectionViewDataSource(
        viewModel: shoppingViewModel
    )
    
    deinit {
        KingfisherManager.shared.cache.clearCache()
    }
    
    override func addChild() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
        self.view.addSubview(indicatorContainerView)
        self.view.addSubview(recommendedCollectionView)
        
        let button = UIBarButtonItem(image: UIImage(systemName: "wifi")?.withTintColor(.label), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
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
        indicatorContainerView.translatesAutoresizingMaskIntoConstraints = false
        recommendedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = shoppingDataSource
        scrollAnimator.delegate = view
        indicatorContainerView.isHidden = true
        
        collectionView.contentInset.bottom = recommededDelegate.cellHeight
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
            indicatorContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            recommendedCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            recommendedCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            recommendedCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            recommendedCollectionView.heightAnchor.constraint(equalToConstant: recommededDelegate.cellHeight)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(recommendedCollectionView)
        view.bringSubviewToFront(indicatorContainerView)
        
        let headerHeight = headerView.bounds.height
        collectionView.contentInset.top = headerHeight
        collectionView.verticalScrollIndicatorInsets.top = headerHeight
    }
    
    @objc
    private func handleRefreshControl(_ sender: UIRefreshControl) {
        shoppingViewModel.refreshTrigger.source(ShoppingSortType.matchTag(self.headerView.selectedIndex))
    }
    
    @objc
    private func headerViewButtonTapped(_ sender: UIButton) {
        shoppingViewModel.sortTypeButtonTrigger.source(ShoppingSortType.matchTag(sender.tag))
    }
    
    override func binding() {
        shoppingViewModel.viewModelBinding()
        
        for (_, value) in headerView.buttonList {
            value.addTarget(self, action: #selector(headerViewButtonTapped(_:)), for: .touchUpInside)
        }
        
        nwTracker.custom_observable_state
            .subscribeOn { [weak self] state in
                DispatchQueue.main.async {
                    let newImage = UIImage(systemName: state.imageString)?
                        .withRenderingMode(.alwaysOriginal)
                        .withTintColor(.label)
                    self?.navigationItem.rightBarButtonItem?.image = newImage
                }
            }
            .disposed(in: bag)

        collectionView.refreshControl!.addTarget(self, action: #selector(handleRefreshControl(_:)), for: .valueChanged)

        self.pagenationController.observe()
        
        shoppingViewModel.isLoadingCell
            .subscribeOn { [weak self] value in
                DispatchQueue.main.async {
                    self?.indicatorContainerView.isHidden = !value
                    if value {
                        self?.indicatorContainerView.indicator.startAnimating()
                    } else {
                        self?.indicatorContainerView.indicator.stopAnimating()
                    }
                }
            }
            .disposed(in: bag)
        
        shoppingViewModel.refreshSignal
            .subscribeOn { [weak self] _ in
                guard let vc = self else { return }
                DispatchQueue.main.async {
                    vc.collectionView.reloadData()
                    vc.shoppingViewModel.guardPaging.source = false
                    vc.shoppingViewModel.isLoadingCell.source = false
                    if vc.collectionView.refreshControl!.isRefreshing == true {
                        vc.collectionView.refreshControl!.endRefreshing()
                        let x = vc.collectionView.contentOffset.x
                        let y = -vc.headerView.bounds.height
                        vc.collectionView.setContentOffset(CGPoint(x: x, y: y), animated: true)
                    }
                }
            }
            .disposed(in: bag)
        
        shoppingViewModel.loadModelSignal
            .subscribeOn { [weak self] _ in
                guard let vc = self else { return }
                DispatchQueue.main.async {
                    let imageList = vc.shoppingViewModel.shoppintList.map(\.image)
                    vc.recommededDataSource.recommendedViewModel.send(imageList)
                    vc.recommendedCollectionView.reloadData()
                }
            }
            .disposed(in: bag)
        
        shoppingViewModel.loadModelSignal
            .subscribeOn { [weak self] _ in
                guard let vc = self else { return }
                DispatchQueue.main.async {
                    vc.collectionView.reloadData()
                    vc.shoppingViewModel.guardPaging.source = false
                    vc.shoppingViewModel.isLoadingCell.source = false
                }
            }
            .disposed(in: bag)
        
        shoppingViewModel.pagingSignal
            .subscribeOn { [weak self] _ in
                guard let vc = self else { return }
                DispatchQueue.main.async {
                    vc.collectionView.reloadData()
                    vc.shoppingViewModel.guardPaging.source = false
                    vc.shoppingViewModel.isLoadingPagingIndicator.source = false
                }
            }
            .disposed(in: bag)
        
        shoppingViewModel.totalCount
            .subscribeOn { [weak self] value in
                let str = "\(String(describing: value.formattedNumber() ?? "")) 개"
                self?.headerView.label.text = str
            }
            .disposed(in: bag)
        
        shoppingViewModel.dataLoadFailed
            .subscribeOn { [weak self] error in
                guard let vc = self else { return }
                DispatchQueue.main.async {
                    vc.showFallBackAlert(error) { [weak self] in
                        guard let self else { return }
                        let sortType = ShoppingSortType.matchTag(self.headerView.selectedIndex)
                        self.dismiss(animated: true, completion: {
                            self.shoppingViewModel.viewDidLoadMergeWithRetryLoadTrigger.source = sortType
                        })
                    } confirm: { [weak self] in
                        self?.dismiss(animated: true)
                    }
                    vc.shoppingViewModel.guardPaging.source = false
                }
            }
            .disposed(in: bag)
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
extension ShoppingResultObservableViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollAnimator.showOrHideHeaderAction(scrollView: scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if shoppingViewModel.shoppintList.count >= 1 {
            return CGSize(
                width: (windowWidth / 2) - 16,
                height: 270
            )
        } else {
            return CGSize(
                width: windowWidth,
                height: 100
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: windowWidth, height: 100)
    }
}


// MARK: PagenationController
extension ShoppingResultObservableViewController {
    fileprivate class PagenationController {
        private weak var scrollView: UIScrollView!
        private weak var viewModel: ShoppingObservableViewModel?
        private var cancellable: AnyCancellable?
        
        init(scrollView: UIScrollView, viewModel: ShoppingObservableViewModel) {
            self.viewModel = viewModel
            self.scrollView = scrollView
        }
        
        func observe() {
            guard let scrollView = self.scrollView else { return }
            cancellable = scrollView.publisher(for: \.contentOffset)
                .removeDuplicates(by: { $0.y == $1.y })
                .filter { [weak self] value in
                    return if let source = self?.viewModel?.guardPaging.source {
                        !source
                    } else {
                        false
                    }
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
                        controller.viewModel?.pagingTrigger.source(())
                    }
                }
        }
    }
}

// MARK: ScrollAnimator
extension ShoppingResultObservableViewController {
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
