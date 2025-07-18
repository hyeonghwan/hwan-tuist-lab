//
//  CityViewController.swift
//  City
//
//  Created by hwan on 7/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Combine

final class CityCollectionSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var cityList: [City] = CityInfo.city
    private var retainSearchField: Bool = false
    
    private weak var citySearchHeader: CitySearchHeaderView? = nil
    
    private lazy var filteredCityList: [ViewModel] = cityList.map { ViewModel(city: $0, contains: nil)} {
        didSet {
            collectionView.reloadSections(IndexSet([1]))
            citySearchHeader?.retainSearchField = self.retainSearchField
            self.retainSearchField = false
        }
    }
    private lazy var emptyContent: Bool = false
    private var subscription: AnyCancellable?
    fileprivate var searchText: String = ""
    
    private struct Query {
        var index: Int
        var text: String
    }
    
    struct ViewModel {
        let city: City
        let contains: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
    }
    
    private func collectionViewSetting() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(
            CitySearchHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CitySearchHeaderView.id
        )
        
        collectionView.register(
            UINib(nibName: CityCollectionCell.id, bundle: nil),
            forCellWithReuseIdentifier: CityCollectionCell.id
        )
        
        collectionView.register(
            EmptyCollectionCell.self,
            forCellWithReuseIdentifier: EmptyCollectionCell.id
        )
    }
    
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        viewEndEditing()
        let touch = sender.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: touch) {
            moveToDetailVC(indexPath: indexPath)
        }
    }
    
    private func mapToTextAndIndex(_ text: String?, current segmentIndex: Int?) -> Query? {
        guard let loweredText = text?.lowercased().removeSpace(), let segmentIndex else {
            return nil
        }
        return Query(index: segmentIndex, text: loweredText)
    }
    
    private func filterUsingSelected(index: Int) -> [City] {
        return switch index {
        case 0:
            cityList
        case 1:
            cityList.filter(\.domesticTravel)
        case 2:
            cityList.filter { !$0.domesticTravel }
        default:
            []
        }
    }
    
    private func viewEndEditing() {
        self.retainSearchField = false
        self.citySearchHeader?.retainSearchField = false
        view.endEditing(true)
    }
}

extension CityCollectionSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewEndEditing()
        return true
    }
}

extension CityCollectionSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    fileprivate func moveToDetailVC(indexPath: IndexPath) {
        if emptyContent { return }
        let model = self.filteredCityList[indexPath.row]
        guard let detailView = storyboard?.instantiateViewController(withIdentifier: CityDetailViewController.id) as? CityDetailViewController else {
            return
        }
        detailView.information = model.city
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    private func headerTextFieldValueChangedSubscribe(header: CitySearchHeaderView) {
        header.searchField.editingChanged
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .compactMap { [weak header, weak self] text in
                self?.mapToTextAndIndex(text, current: header?.segmentedControl.selectedSegmentIndex)
            }
            .sink { [weak self] query in
                guard let self else { return }
                let filterCity = self.filterUsingSelected(index: query.index)
                let resultList = query.text.isEmpty ? filterCity : filterCity.searchPrefix(query.text)
                self.retainSearchField = true
                self.searchText = query.text
                self.filteredCityList = resultList.map { ViewModel(city: $0, contains: query.text) }
            }.store(in: &header.subscriptions)
    }
    
    private func headerSegmentedControlValueChangedSubscribe(header: CitySearchHeaderView) {
        header.segmentedControl.selectionPublisher
            .sink { [weak header, weak self] value in
                self?.viewEndEditing()
                header?.searchField.text = ""
                if let city = self?.filterUsingSelected(index: header?.segmentedControl.selectedSegmentIndex ?? 0) {
                    self?.filteredCityList = city.map { ViewModel(city: $0, contains: nil) }
                }
            }.store(in: &header.subscriptions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewEndEditing()
        self.moveToDetailVC(indexPath: indexPath)
        self.collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section != 0 {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CitySearchHeaderView.id,
            for: indexPath
        ) as? CitySearchHeaderView else {
            return UICollectionReusableView()
        }
        
        header.searchField.delegate = self
        headerTextFieldValueChangedSubscribe(header: header)
        headerSegmentedControlValueChangedSubscribe(header: header)
        self.citySearchHeader = header
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if filteredCityList.count == 0 {
                emptyContent = true
                return 1
            } else {
                emptyContent = false
                return filteredCityList.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 { return UICollectionViewCell() }
        
        if emptyContent {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionCell.id, for: indexPath) as? EmptyCollectionCell else {
                return UICollectionViewCell()
            }
            
            cell.set(keyword: searchText)
            return cell
        }
        
        let viewModel = filteredCityList[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionCell.id, for: indexPath) as? CityCollectionCell else {
            return UICollectionViewCell()
        }
        cell.set(info: viewModel.city, contains: viewModel.contains)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewEndEditing()
    }
}


extension CityCollectionSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            if emptyContent {
                return CGSize(width: view.windowWidth, height: 150)
            } else {
                return if view.windowWidth < view.windowHeight {
                    CGSize(
                        width: Int((view.windowWidth / 2) - 26),
                        height: Int((view.windowHeight / 3) - 16)
                    )
                } else {
                    CGSize(
                        width: Int((view.windowHeight / 2) - 26),
                        height: Int((view.windowWidth / 3) - 16)
                    )
                }
            }
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.windowWidth, height: 100)
        }
        return .zero
    }
}
