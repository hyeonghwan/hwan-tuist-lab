//
//  TravelTalkViewController.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import HwanMacros

@Logging
final class TravelTalkViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var safeAreaBottomToCollectionViewBottom: NSLayoutConstraint!
    
    private var models: [ChatRoom] = ChatList.list
    private var filtered: [ChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetting()
        searchBarSetting()
        configureLayout()
        collectionViewSetting()
    }
    
    private func navigationSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func searchBarSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "친구 이름을 검색해보세요"
        self.navigationItem.title = "TRAVEL TALK"
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    private func configureLayout() {
        collectionView.layer.borderColor = UIColor.red.cgColor
        collectionView.layer.cornerRadius = 12
        safeAreaBottomToCollectionViewBottom.isActive = false
        let constraint = view.keyboardLayoutGuide.topAnchor
            .constraint(
                equalToSystemSpacingBelow: collectionView.bottomAnchor,
                multiplier: 1.0
            )
        view.keyboardLayoutGuide.setConstraints([constraint], activeWhenAwayFrom: .top)
    }
    
    private func collectionViewSetting() {
        collectionView.register(
            UINib(nibName: TravelTalkCell.id, bundle: nil),
            forCellWithReuseIdentifier: TravelTalkCell.id
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        collectionView.collectionViewLayout = layout
    }
}

extension TravelTalkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: UIScreen.main.bounds.width,
            height: 82
        )
    }
}

extension TravelTalkViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatRoom = models[indexPath.row]
        let chatRoomVC = storyboard?.instantiateViewController(withIdentifier: ChatRoomViewController.id) as! ChatRoomViewController
        chatRoomVC.chatRoom = chatRoom
        chatRoomVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(
            chatRoomVC,
            animated: true
        )
    }
}

extension TravelTalkViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TravelTalkCell.id, for: indexPath) as? TravelTalkCell else {
            return UICollectionViewCell()
        }
        cell.configure(info: models[indexPath.row])
        return cell
    }
}


extension TravelTalkViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint(String(describing: searchController.searchBar.text))
    }
}
