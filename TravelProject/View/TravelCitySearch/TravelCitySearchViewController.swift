//
//  TravelCitySearchViewController.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit
import Combine

// 여행 국가 탐색 화면 만들기 (옵션이지만, 해보시길권장드립니다)
// 여행 프로젝트에서,새로운 탭바를 추가하여 CityInfo.swift 를 활용해 여행 국가 탐색 화면을 구성해봅니다.
// 세그먼트컨트롤과 텍스트필드를 통해 데이터를 필터해보는게 더 중요하기 때문에, 시간이 충분하지 않다면 XIB Cell
// Design 은 레이블 만 얹어서 구성해보셔도 됩니다!
// - 구조체는 제공된 데이터를 유추해서, 직접 생성해보세요
// - city_name, city_english_name, city_explain, city_image 4가지 정보를 활용해주세요.
// - city_image는 Kingfisher 라이브러리를 활용합니다.
// 1. UITableViewController + XIB Cell 로 구성하기
// 2. CityInfo.swift 데이터를 활용해 테이블뷰에 데이터 표현하기
// 3. UITableView HeaderView에 UISegmentedControl 를 추가해, 세그먼트
// 선택에 따라 해당하는 도시 정보만 테이블뷰에 보여주기 (domestic_travel 활
// 용)
// 4. UISegmentedControl 상단에 UITextField 를 추가해
//      1) 엔터키 클릭 시 검색 2) 실시간 검색 기능을 구현하기
//- 만약 세그먼트를 국내로 설정하고 텍스트필드에서 검색하는 경우, 국내에 해당하는 데이터 중에서 검색 기능을 구현해보세요.
//- city_name, city_english_name, city_explain 에서 하나라도 검색 키워드가 포함되어 있다면 검색 결과로 보여줍니다.
//- (옵션) 대소문자 구분없이 검색 하기
//- (옵션) 서치바에서 공백을 입력한 경우, whitespace 처리하기
//- (옵션) 검색 키워드에 해당하는 글자에 텍스트 컬러 일부 변경해보기

final class TravelCitySearchViewController: UIViewController {
    private weak var header: CitySearchHeaderView?
    @IBOutlet weak var tableView: UITableView!
    private var cityList: [City] = CityInfo.city
    private lazy var filteredCityList: [City] = cityList {
        didSet {
            tableView.reloadData()
        }
    }
    private var subscription: AnyCancellable?
    
    private struct Query {
        var index: Int
        var text: String
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        print("\(Self.self), \(#function)")
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
                    self.filteredCityList = query.text.isEmpty ? filterCity : filterCity.searchPrefix(query.text)
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
        filteredCityList = filterUsingSelected(index: header?.segmentedControl.selectedSegmentIndex ?? 0)
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
