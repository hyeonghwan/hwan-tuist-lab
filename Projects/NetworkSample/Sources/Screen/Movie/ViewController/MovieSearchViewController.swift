//
//  MovieSearchViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design


final class MovieSearchViewController: BaseViewController {
    
    private let textField: BottomLayerTextField = {
        let field = BottomLayerTextField()
        field.placeholder = "검색어를 입력해주세요"
        field.tintColor = .white
        field.setPlaceholder(color: .white.withAlphaComponent(0.6))
        field.textColor = .white
        field._btBorderHeight = 4
        field._btBorderColor = UIColor.white.cgColor
        return field
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .bold)
        configuration.attributedTitle = AttributedString("검색", attributes: container)
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.cornerStyle = .fixed
        button.configuration = configuration
        button.addAction(UIAction(handler: { [weak self] _ in self?.sendAction() }),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MovieInfoCell.self,
            forCellReuseIdentifier: MovieInfoCell.id
        )
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.estimatedRowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var boxOfficeLists: [DailyBoxOfficeDTO] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func addChild() {
        view.addSubview(textField)
        view.addSubview(searchButton)
        view.addSubview(tableView)
    }
    
    override func addAttributes() {
        view.backgroundColor = .black
        tableView.backgroundColor = view.backgroundColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(keyboardDismiss(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 80),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func binding() {
        let yesterDay = Date.yesterday.toFormatted("yyyyMMdd")
        request(day: yesterDay) { [weak self] response in
            self?.boxOfficeLists = response.boxOfficeResult.dailyBoxOfficeList
        }
    }
    
    private func request(day: String, _ completion: @escaping (BoxOfficeResultDTO) -> Void) {
        CoreNetwork.shared.GET(
            resource: KobisOpenApiResource(query: MovieQuery(targetDt: "\(day)")),
            type: BoxOfficeResultDTO.self
        ) { result in
            switch result {
            case let .success(dto):
                completion(dto)
                debugPrint(dto)
                
            case let .failure(error):
                debugPrint(error)
            }
        }
    }
    
    private func sendAction() {
        let text = self.textField.text
        self.textField.text = ""
        self.textField.resignFirstResponder()
        if let date = text?.toDate("yyyyMMdd") {
            request(day: date.toFormatted("yyyyMMdd")) { [weak self] response in
                self?.boxOfficeLists = response.boxOfficeResult.dailyBoxOfficeList
            }
        } else {
            showAlert(
                title: "입력값",
                message: "20201210 (년도월일) 형식으로 입력해주세요 ",
                action: [AlertAction(text: "확인", color: .black) { self.dismiss(animated: true)}]
            )
        }
    }
}

extension MovieSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            sendAction()
            return false
        }
        return true
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boxOfficeLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieInfoCell.id) as? MovieInfoCell else {
            fatalError()
        }
        cell.configure(boxOffice: boxOfficeLists[indexPath.row], index: indexPath.row + 1)
        cell.backgroundColor = self.view.backgroundColor
        cell.selectionStyle = .none
        return cell
    }
}
