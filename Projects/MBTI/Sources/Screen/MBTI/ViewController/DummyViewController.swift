//
//  DummyViewController.swift
//  MBTI
//
//  Created by hwan on 8/14/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class DummyViewController: BaseViewController {
    let uibutton = UIButton()
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(uibutton)
        
        uibutton.setTitle("다시 돌아가기", for: .normal)
        uibutton.setTitleColor(.label, for: .normal)
        uibutton.translatesAutoresizingMaskIntoConstraints = false
        
        uibutton.addTarget(self, action: #selector(returnToMBTI(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            uibutton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uibutton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc
    private func returnToMBTI(_ sender: UIButton) {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow })
        {
            let vc = MBTIViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            window.rootViewController = nav
        }
    }
}
