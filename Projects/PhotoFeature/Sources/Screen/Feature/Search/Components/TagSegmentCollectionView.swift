//
//  TagSegmentedView.swift
//  PhotoFeature
//
//  Created by hwan on 8/15/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design
import CustomObservable

typealias TagCell = TagSegmentCollectionView.TagCell

final class TagSegmentCollectionView: BaseCollectiionView {
    
    convenience init(_ dataSource: DataSource, _ delegate: TagDelegate) {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 2
        flowlayout.scrollDirection = .horizontal
        flowlayout.estimatedItemSize = CGSize(width: 100, height: 28)
        self.init(frame: .zero, collectionViewLayout: flowlayout)
        self.dataSource = dataSource
        self.delegate = delegate
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 66)
    }
    
    override func addAttributes() {
        self.register(
            TagCell.self,
            forCellWithReuseIdentifier: TagCell.id
        )
    }
    
    final class TagDelegate: NSObject, UICollectionViewDelegate {
        weak var selectedTrigger: LazyObservable<TagModel?>?
        
        init(selectedTrigger: LazyObservable<TagModel?>) {
            self.selectedTrigger = selectedTrigger
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let tagDataSource = (collectionView as? TagSegmentCollectionView)?.dataSource,
               let tagDataSource = tagDataSource as? TagSegmentCollectionView.DataSource {
                let model = tagDataSource.models[indexPath.row]
                
                if model.isSelected == true {
                    tagDataSource.models[indexPath.row].isSelected = false
                    selectedTrigger?.source(.next(nil))
                    
                    CATransaction.begin()
                    CATransaction.setValue(true, forKey: kCATransactionDisableActions)
                    collectionView.reloadItems(at: [indexPath])
                    CATransaction.commit()
                    
                } else {
                    selectedTrigger?.source(.next(model))
                }
            }
        }
    }


    
    final class DataSource: NSObject, UICollectionViewDataSource {
        var models = TagModel.allCases
        
        func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { models.count }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.id, for: indexPath) as! TagCell
            
            tagCell.set(
                isSelected: models[indexPath.row].isSelected,
                color: models[indexPath.row].color.color,
                title: models[indexPath.row].color.title
            )
            
            return tagCell
        }
    }
    
    final class TagCell: BaseCollectionViewCell, CellIdentifialble {
        private let colorView = UIView()
        private let titleLabel = UILabel()
        
        override func addAttributes() {
            self.contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
            self.contentView.layer.cornerRadius = 14
            colorView.layer.cornerRadius = 10
            colorView.clipsToBounds = true
            titleLabel.textColor = .label
            titleLabel.font = .systemFont(ofSize: 12, weight: .light)
        }
        
        override func addChild() {
            self.contentView.addSubview(colorView)
            self.contentView.addSubview(titleLabel)
            colorView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
        }
        
        override func addLayout() {
            colorView.setContentHuggingPriority(.required, for: .vertical)
            NSLayoutConstraint.activate([
                colorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4),
                colorView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
                colorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4),
                colorView.widthAnchor.constraint(equalToConstant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: self.colorView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: self.colorView.trailingAnchor, constant: 6),
                titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -6)
            ])
        }
        
        func set(isSelected: Bool, color: UIColor, title: String) {
            self.colorView.backgroundColor = color
            self.titleLabel.text = title
            self.contentView.backgroundColor =
            isSelected
            ?
            .blue.withAlphaComponent(0.3)
            :
            .lightGray.withAlphaComponent(0.3)
        }
    }
}
