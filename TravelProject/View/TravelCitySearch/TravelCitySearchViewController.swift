//
//  TravelCitySearchViewController.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit

final class TravelCitySearchViewController: UIViewController {
    private weak var header: CitySearchHeaderView?
    @IBOutlet weak var tableView: UITableView!
    private var cityList: [City] = CityInfo.city
    private lazy var filteredCityList: [City] = cityList {
        didSet {
            tableView.reloadData()
        }
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
        filteredCityList = filterUsingSelected(index: header?.segmentedControl.selectedSegmentIndex ?? 0)
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

extension TravelCitySearchViewController: UITableViewDelegate, UITableViewDataSource {
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
        let model = filteredCityList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.id, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.set(info: model)
        cell.selectionStyle = .none
        return cell
    }
}
