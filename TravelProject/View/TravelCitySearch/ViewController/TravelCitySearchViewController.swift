//
//  TravelCitySearchViewController.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit
import Combine

// - (옵션) 검색 키워드에 해당하는 글자에 텍스트 컬러 일부 변경해보기
final class TravelCitySearchViewController: UIViewController {
    private weak var header: CitySearchHeaderView?
    @IBOutlet weak var tableView: UITableView!
    private var cityList: [City] = CityInfo.city
    private lazy var filteredCityList: [ViewModel] = cityList.map { ViewModel(city: $0, contains: nil)} {
        didSet {
            tableView.reloadData()
        }
    }
    private var subscription: AnyCancellable?
    
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
        tableViewSetting()
        header?.segmentedControl.addTarget(
            self,
            action: #selector(segmentedValueChanged(_:)),
            for: .valueChanged
        )
        searchFieldSubscribe()
    }
    
    private func searchFieldSubscribe() {
        if let header {
            header.searchField.delegate = self
            subscription = header.searchField.editingChanged
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .compactMap { [weak self] text in
                    self?.mapToTextAndIndex(text)
                }
                .sink { [weak self] query in
                    guard let self else { return }
                    let filterCity = self.filterUsingSelected(index: query.index)
                    let resultList = query.text.isEmpty ? filterCity : filterCity.searchPrefix(query.text)
                    self.filteredCityList = resultList.map { ViewModel(city: $0, contains: query.text) }
                }
        }
    }
    
    private func tableViewSetting() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        let header = CitySearchHeaderView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
        )
        tableView.tableHeaderView = header
        self.header = header
        
        tableView.register(
            UINib(nibName: CityCell.id, bundle: nil),
            forCellReuseIdentifier: CityCell.id
        )
    }
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        self.header?.searchField.text = ""
        let city = filterUsingSelected(index: header?.segmentedControl.selectedSegmentIndex ?? 0)
        filteredCityList = city.map { ViewModel(city: $0, contains: nil) }
    }
    
    private func mapToTextAndIndex(_ text: String?) -> Query? {
        guard let loweredText = text?.lowercased().removeSpace() else {
            return nil
        }
        let index = header?.segmentedControl.selectedSegmentIndex ?? 0
        return Query(index: index, text: loweredText)
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
}

extension TravelCitySearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension TravelCitySearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = filteredCityList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.id, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.set(info: viewModel.city, contains: viewModel.contains)
        cell.selectionStyle = .none
        return cell
    }
}
