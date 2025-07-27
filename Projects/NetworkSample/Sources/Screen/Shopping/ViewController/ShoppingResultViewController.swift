//
//  ShoppingResultViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import HwanMacros
import Combine

@Logging
final class ShoppingResultViewController: BaseViewController {
    private let headerView = ShoppingHeaderView()
    private let collectionView = ShoppingCollectionView()
    private let refreshControl = UIRefreshControl()
    
    private let scrollAnimator = ScrollAnimator()
    private lazy var pagenationController = PagenationController(
        scrollView: collectionView,
        pagingSubject: shoppingPagingSubject
    )
    private let shoppingPagingSubject = PassthroughSubject<Void, Never>()
    
    override func addChild() {
        self.view.addSubview(headerView)
        self.view.addSubview(collectionView)
    }
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        self.refreshControl.tintColor = .orange
        
        navigationSetting()
        
        collectionView.refreshControl = refreshControl
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = shoppingDataSource
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
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        view.bringSubviewToFront(headerView)
        
        let headerHeight = headerView.bounds.height
        collectionView.contentInset.top = headerHeight
        collectionView.verticalScrollIndicatorInsets.top = headerHeight
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
        CGSize(
            width: (windowWidth / 2) - 16,
            height: 270
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: windowWidth, height: 100)
    }
}


// MARK: PagenationController
extension ShoppingResultViewController {
    @Logging
    fileprivate class PagenationController {
        private weak var scrollView: UIScrollView!
        private var pagingSubject: PassthroughSubject<(Void), Never>
        private var cancellable: AnyCancellable?
        
        init(scrollView: UIScrollView, pagingSubject: PassthroughSubject<Void, Never>) {
            self.pagingSubject = pagingSubject
            self.scrollView = scrollView
        }
        
        func observe(_ isApiLoading: AnyPublisher<Bool, Never>) {
            guard let scrollView = self.scrollView else { return }
            cancellable = scrollView.publisher(for: \.contentOffset)
                .removeDuplicates(by: { $0.y == $1.y })
                .throttle(for: .milliseconds(600), scheduler: DispatchQueue.main, latest: true)
                .combineLatest(isApiLoading)
                .filter { (_, isLoading) in
                    return !isLoading
                }
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
                        self.pagingSubject.send()
                    }
                }
        }
        
        private func logging(pointY: CGFloat) {
            // let logString = """
            //  \(#function) -
            //  offsetY: \(offsetY)
            //  request to viewmodel totalOFfset: \(totalOffset)
            //  contentHeight: \(contentHeight - 200)
            //  isRequest: \(totalOffset > (contentHeight * 3) / 4),
            //  viewModel.isApiLoadingSubject: \(String(describing: self.viewModel.isApiLoadingSubject.value))
            //  """
            // self.logger.log(
            //     level: .info,
            //     "\(logString)"
            // )
            let contentSize = self.scrollView?.contentSize ?? CGSize(width: 0, height: 0)
            let boundsHeight = self.scrollView?.bounds.height ?? 0
            let log = """
            \(Self.self) ----------------------------------------------------- 
            contentOffsetY: \(String(describing: pointY))
            bounds.height:  \(String(describing: boundsHeight))
            offsetY + bound.height \(pointY + boundsHeight)
            contentSize:    \(String(describing: contentSize))
            ------------------------------------------------------------------
            """
            self.logger.log(
                level: .info,
                "\(log)"
            )
        }
    }
}
extension ShoppingResultViewController {
    @Logging
    fileprivate class ScrollAnimator: NSObject {
        var headerViewTopAnchor: NSLayoutConstraint!
    }
}
