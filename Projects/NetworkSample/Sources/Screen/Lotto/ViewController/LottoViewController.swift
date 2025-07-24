//
//  LottoViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/23/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class LottoViewController: BaseViewController {
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        return textField
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.text = "당첨번호 안내"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.text = "2020-05-30 추첨"
        return label
    }()
    
    private let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .separator.withAlphaComponent(0.5)
        return view
    }()
    
    private let datePicker = UIPickerView()
    
    private let countResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 21)
        label.text = "00회 당첨결과"
        return label
    }()
    
    private var lottoNumberViewList: [LottoBallView] = {
        var result = [LottoBallView]()
        for i in 1...8 {
            let ball = LottoBallView()
            ball.number = 0
            if i == 7 {
                ball.number = -1
            }
            result.append(ball)
        }
        return result
    }()
    
    private lazy var horizontalStack: UIStackView  = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .equalCentering
        return stack
    }()
    
    private let bonusLabel: UILabel = {
        let label = UILabel()
        label.text = "보너스"
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .label
        return label
    }()
    
    private var numbers = (1...1181).map { $0 }
    private var cache: [Int: LottoResult] = [:]
    
    override func addChild() {
        view.addSubview(textField)
        view.addSubview(infoLabel)
        view.addSubview(dateLabel)
        view.addSubview(separatorView)
        view.addSubview(countResultLabel)
        view.addSubview(horizontalStack)
        view.addSubview(bonusLabel)
        for i in 0...7 {
            horizontalStack.addArrangedSubview(lottoNumberViewList[i])
        }
    }
    
    override func addAttributes() {
        view.backgroundColor = .systemBackground
        textField.inputView = datePicker
        textField.delegate = self
        datePicker.delegate = self
        datePicker.dataSource = self
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        [textField, infoLabel, dateLabel ,separatorView, countResultLabel, bonusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(keyboardDismiss(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func addLayout() {
        let bonusBall = lottoNumberViewList[lottoNumberViewList.count - 1]
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            infoLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            dateLabel.centerYAnchor.constraint(equalTo: infoLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            separatorView.heightAnchor.constraint(equalToConstant: 0.6),
            separatorView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            separatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            countResultLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 24),
            countResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            horizontalStack.topAnchor.constraint(equalTo: countResultLabel.bottomAnchor, constant: 24),
            horizontalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            bonusLabel.topAnchor.constraint(equalTo: bonusBall.bottomAnchor, constant: 4),
            bonusLabel.centerXAnchor.constraint(equalTo: bonusBall.centerXAnchor)
        ])
    }
    
    
    
    
    private func animationBalls(isAnimate: Bool = false) {
        let value = isAnimate == true ? nil : 0
        for i in 1...8 {
            if i == 7 { continue }
            lottoNumberViewList[i - 1].number = value
        }
    }
    
    /// Request Lotto Number drwno
    /// - Parameters:
    ///   - drwNo: 로또 회차
    ///   - completion: 데이터 송신시 Hadling 처리
    private func request(_ drwNo: Int, _ completion: @escaping (LottoDTO) -> Void) {
        let resource = LottoApiResource()
        animationBalls(isAnimate: true)
        CoreNetwork.shared.get(
            resource: resource,
            type: LottoDTO.self,
            queries: [ "method": "getLottoNumber", "drwNo": "\(drwNo)"]) { [weak self] result in
                switch result {
                case let .success(dto):
                    completion(dto)
                case let .failure(error):
                    self?.animationBalls(isAnimate: false)
                    debugPrint("XXXXXXX Failed XXXXXXX \(error)")
                }
            }
    }
    
    private func dataLoadUsingFile() {
        guard let url = Bundle.main.url(forResource: "Lotto", withExtension: "json") else {
            return
        }
        if let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let value = try decoder.decode([LottoResult].self, from: data)
                cache = value.reduce(into: [Int: LottoResult]()) { origin, value in
                    origin[value.drawNo] = value
                }
            } catch {
                return
            }
        }
    }
}

extension LottoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension LottoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(numbers[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = numbers[row]
        textField.text = "\(selectedNumber)"
        
        let color = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemYellow, UIColor.systemGray].randomElement()!
        
        let mutableString = NSMutableAttributedString()
        
        mutableString.append(NSAttributedString(string: "\(selectedNumber)회", attributes: [
            .font : UIFont.boldSystemFont(ofSize: 23),
            .foregroundColor : color.withAlphaComponent(0.6)
        ]))
        
        mutableString.append(NSAttributedString(string: " 당첨결과", attributes: [
            .font : UIFont.systemFont(ofSize: 23),
            .foregroundColor : UIColor.label
        ]))
        
        countResultLabel.attributedText = mutableString
        
        self.request(selectedNumber) { [weak self] dto in
            guard let self else { return }
            lottoNumberViewList[0].number = dto.drwtNo1
            lottoNumberViewList[1].number = dto.drwtNo2
            lottoNumberViewList[2].number = dto.drwtNo3
            lottoNumberViewList[3].number = dto.drwtNo4
            lottoNumberViewList[4].number = dto.drwtNo5
            lottoNumberViewList[5].number = dto.drwtNo6
            lottoNumberViewList[7].number = dto.bnusNo
            dateLabel.text = "\(dto.drwNoDate) 추첨"
        }
    }
}
