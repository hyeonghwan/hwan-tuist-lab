//
//  MBTIViewController.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class MBTIViewController: BaseViewController {
    
    private let phtoSelectView = PhotoSelectView(isCameraAppear: true)
    private let textField = BottomLayerTextField()
    private let informationLabel = UILabel()
    
    private let mbtiLabel = UILabel()
    
    private let ei = MBTIButtonGroup.eiStack
    private let sn = MBTIButtonGroup.snStack
    private let tf = MBTIButtonGroup.tfStack
    private let jp = MBTIButtonGroup.jpStack
    
    private let confirmButton = UIButton()
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        
        informationLabel.text = "닉네임에 숫자는 포함할 수 없어요"
        informationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        informationLabel.textColor = .label
        
        mbtiLabel.text = "MBTI"
        mbtiLabel.textColor = .label
        mbtiLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        confirmButton.layer.cornerRadius = 16
        confirmButton.clipsToBounds = true
        confirmButton.setTitle("완료", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setBackgroundColor(.disabledButtonColor, for: .disabled)
        confirmButton.setBackgroundColor(.validStateColor, for: .normal)
        
        navigationSetting()
    }
    
    private func navigationSetting() {
        navigationItem.title = "PROFILE SETTING"
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = .systemBackground
        navigationAppearance.shadowColor = .systemGray
        navigationAppearance.titleTextAttributes =  [.foregroundColor : UIColor.label]
        self.navigationController?.navigationBar.standardAppearance = navigationAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
    }
    
    override func addChild() {
        self.view.addSubview(phtoSelectView)
        self.view.addSubview(textField)
        self.view.addSubview(informationLabel)
        self.view.addSubview(ei)
        self.view.addSubview(sn)
        self.view.addSubview(tf)
        self.view.addSubview(jp)
        self.view.addSubview(mbtiLabel)
        self.view.addSubview(confirmButton)
        phtoSelectView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        ei.translatesAutoresizingMaskIntoConstraints = false
        sn.translatesAutoresizingMaskIntoConstraints = false
        tf.translatesAutoresizingMaskIntoConstraints = false
        jp.translatesAutoresizingMaskIntoConstraints = false
        mbtiLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            phtoSelectView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 28),
            phtoSelectView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            phtoSelectView.widthAnchor.constraint(equalToConstant: 100),
            phtoSelectView.heightAnchor.constraint(equalToConstant: 100),
            
            textField.topAnchor.constraint(equalTo: phtoSelectView.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            informationLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            informationLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            
            mbtiLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 40),
            mbtiLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            ei.topAnchor.constraint(equalTo: mbtiLabel.topAnchor),
            ei.trailingAnchor.constraint(equalTo: sn.leadingAnchor, constant: -8),
            
            sn.topAnchor.constraint(equalTo: mbtiLabel.topAnchor),
            sn.trailingAnchor.constraint(equalTo: tf.leadingAnchor, constant: -8),
            
            tf.topAnchor.constraint(equalTo: mbtiLabel.topAnchor),
            tf.trailingAnchor.constraint(equalTo: jp.leadingAnchor, constant: -8),
            
            jp.topAnchor.constraint(equalTo: mbtiLabel.topAnchor),
            jp.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            confirmButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor, constant: -12),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private let viewModel = MBTIViewModel()
    private var bag = Bag()
    private let textEditingChanged = EagerObservable<String>(source: .next(""))
    
    @objc
    private func textDidChange(_ textField: UITextField) {
        textEditingChanged.source = .next(textField.text!)
    }
    
    @objc
    private func moveToSelectedViewController(_ sender: Any) {
        let vc = PhotoSelectViewController.create(with: self.viewModel)
        navigationItem.backButtonTitle = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func moveToOtherWindowRootViewContrller(_ sender: UIButton) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow })
        {
            window.rootViewController = DummyViewController()
        }
    }
    
    override func binding() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        self.phtoSelectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToSelectedViewController(_:))))
        self.confirmButton.addTarget(self, action: #selector(moveToOtherWindowRootViewContrller(_:)), for: .touchUpInside)
        
        let output = viewModel.transform(
            input: .init(
                ei: ei.selectedObservable,
                sn: sn.selectedObservable,
                tf: tf.selectedObservable,
                jp: jp.selectedObservable,
                textEditingChanged: textEditingChanged
            )
        )
        
        output.viewModelState
            .subscribeOn { [weak self] state in
                let mbti = state.mbtiState.joined()
                
                self?.informationLabel.text = state.inputStatus.rawValue
                self?.informationLabel.textColor = state.inputStatus.color
                
                if mbti.count >= 4 && state.inputStatus == .valid {
                    self?.confirmButton.isEnabled = true
                } else {
                    self?.confirmButton.isEnabled = false
                }
                
                self?.phtoSelectView.setImage(Avatar.getImage(state.photo))
            }
            .disposed(in: bag)
    }
}
