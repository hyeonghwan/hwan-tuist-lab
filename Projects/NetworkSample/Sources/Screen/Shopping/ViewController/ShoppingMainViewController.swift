//
//  ShoppingMainViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import HwanMacros

@Logging
final class ShoppingMainViewController: BaseViewController {

    private let imageView = UIImageView()
    private var _cancelCliked = false
    
    override func addChild() {
        view.addSubview(imageView)
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(keyboardHideAction(_:)))
    }
    
    override func addAttributes() {
        searchBarSetting()
        self.view.backgroundColor = .systemBackground
        imageView.image = UIImage(systemName: "cart.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: windowWidth / 3 * 2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.1)
        ])
    }
    
    private func searchBarSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.lightGray
        ]
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "브랜드, 상품, 프로필, 태그 등",
            attributes: attributes
        )
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .label
        self.navigationItem.title = "Hwan의 Shopping"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
}

extension ShoppingMainViewController: UISearchBarDelegate {
    private var cancelCliked: Bool {
        get { _cancelCliked }
        set { _cancelCliked = newValue }
    }
    
    fileprivate func showFallBackAlert() {
        let ok = AlertAction(text: "확인", color: .black) { [weak self] in
            self?.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
        let cancel = AlertAction(text: "취소", color: .red) { [weak self] in
            self?.navigationItem.searchController?.searchBar.text = ""
        }
        showAlert(title: "입력", message: "최소 2글자 이상 입력해주세요!", action: cancel, ok)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelCliked = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let searchQuery = searchBar.text!
        if searchQuery.count < 2 {
            if cancelCliked {
                cancelCliked = false
                return
            }
            showFallBackAlert()
            return
        }
        searchBar.text = ""
        self.hideKeyboard()
        let vc = ShoppingResultViewController()
        vc.navigationItem.title = "\(searchQuery)"
        navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShoppingMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        logger.log(level: .info, "\(#function) \(String(describing: searchController.searchBar.text!))")
    }
}

extension BaseViewController {
    fileprivate func hideKeyboard() {
        self.navigationItem.searchController?.searchBar.endEditing(true)
    }
    
    @objc func keyboardHideAction(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }
}
