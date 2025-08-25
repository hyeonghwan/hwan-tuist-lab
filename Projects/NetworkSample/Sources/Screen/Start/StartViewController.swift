//
//  StartViewController.swift
//  NetworkSample
//
//  Created by hwan on 7/24/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class StartViewController: BaseViewController {
    let toLotto = UIButton()
    let toMovie = UIButton()
    
    override func addChild() {
        view.addSubview(toLotto)
        view.addSubview(toMovie)
    }
    
    override func addAttributes() {
        view.backgroundColor = .black
        toLotto.translatesAutoresizingMaskIntoConstraints = false
        toLotto.setTitle("로또 화면 이동", for: .normal)
        toLotto.setTitleColor(.white, for: .normal)
        toLotto.addTarget(self, action: #selector(toLotto(_:)), for: .touchUpInside)
        
        toMovie.setTitle("영화 검색 화면 이동", for: .normal)
        toMovie.translatesAutoresizingMaskIntoConstraints = false
        toMovie.setTitleColor(.white, for: .normal)
        toMovie.addTarget(self, action: #selector(toMovie(_:)), for: .touchUpInside)
    }
    
    override func addLayout() {
        NSLayoutConstraint.activate([
            toLotto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            toLotto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toLotto.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            toLotto.heightAnchor.constraint(equalToConstant: 44),
            
            toMovie.topAnchor.constraint(equalTo: toLotto.bottomAnchor, constant: 100),
            toMovie.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toMovie.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            toMovie.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    func toLotto(_ sender: UIButton) {
        let vc = LottoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func toMovie(_ sender: UIButton) {
        let vc = MovieSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
