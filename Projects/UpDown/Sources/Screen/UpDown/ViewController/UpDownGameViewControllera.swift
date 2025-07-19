//
//  UpDownGameViewControllera.swift
//  UpDown
//
//  Created by hwan on 7/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

typealias GameViewModel = UpDownGameViewController.ViewModel

final class UpDownGameViewController: UIViewController, CellIdentifialble {
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var resultButton: UIButton!
    
    var items = [Int]() {
        didSet {
            self.viewModels = self.items.map {
                ViewModel(
                    item: $0,
                    selected: false
                )
            }
        }
    }
    private var selectedIndexPath: IndexPath? = nil {
        didSet {
            if selectedIndexPath != nil {
                update(oldValue: oldValue, newValue: selectedIndexPath)
            }
        }
    }
    private var viewModels = [ViewModel]()
    private lazy var answer: Int = items.randomElement()!
    private var submitCount = 0
    
    struct ViewModel {
        let item:     Int
        var selected: Bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func collectionViewSetting() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumInteritemSpacing = 4
        layout.minimumInteritemSpacing = 4
        let spacing: CGFloat = 8
        layout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
        layout.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = layout
        collectionView.register(
            UINib(nibName: NumberCell.id, bundle: nil),
            forCellWithReuseIdentifier: NumberCell.id
        )
        collectionView.dataSource = self
        collectionView.delegate   = self
        resultButton.addTarget(
            self,
            action: #selector(resultButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    @objc
    private func resultButtonTapped(_ sender: UIButton) {
        if let selectedIndexPath {
            let number = viewModels[selectedIndexPath.row].item
            if number > answer {
                directionLabel.text = "Down"
                viewModels = Array(viewModels[0..<selectedIndexPath.row])
            } else if number < answer {
                directionLabel.text = "Up"
                viewModels = Array(viewModels[(selectedIndexPath.row + 1)..<viewModels.count])
            } else {
                directionLabel.text = "GOOD !"
            }
            countLabel.text = "시도 횟수: \(submitCount + 1)"
            self.submitCount += 1
            self.selectedIndexPath = nil
            self.collectionView.reloadData()
        } else {
            
        }
    }
    
    private func update(oldValue: IndexPath?, newValue: IndexPath?) {
        if let oldValue, let newValue {
            self.viewModels[oldValue.row].selected = false
            self.viewModels[newValue.row].selected = true
            collectionView.reloadItems(at: [oldValue, newValue])
        } else if let newValue {
            self.viewModels[newValue.row].selected = true
            collectionView.reloadItems(at: [newValue])
        }
    }
}

extension UpDownGameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}

extension UpDownGameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCell.id, for: indexPath) as? NumberCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: viewModels[indexPath.row])
        return cell
    }
}
