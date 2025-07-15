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
