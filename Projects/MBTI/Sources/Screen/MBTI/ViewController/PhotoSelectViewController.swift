//
//  PhotoSelectViewController.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class PhotoSelectViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let topPhotoSelectView = PhotoSelectView(isCameraAppear: true, radius: 50)
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var viewModel: MBTIViewModel?
    
    static func create(with viewModel: MBTIViewModel) -> PhotoSelectViewController {
        let vc = PhotoSelectViewController()
        vc.viewModel = viewModel
        vc.topPhotoSelectView.setImage(Avatar.getImage(viewModel.photo))
        return vc
    }
    
    override func addAttributes() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "PROFILE SETTING"
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
    }

    override func addChild() {
        self.view.addSubview(topPhotoSelectView)
        self.view.addSubview(collectionView)
        topPhotoSelectView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func addLayout() {
        NSLayoutConstraint.activate([
            topPhotoSelectView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24),
            topPhotoSelectView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            topPhotoSelectView.widthAnchor.constraint(equalToConstant: 100),
            topPhotoSelectView.heightAnchor.constraint(equalToConstant: 100),
            collectionView.topAnchor.constraint(equalTo: topPhotoSelectView.bottomAnchor, constant: 38),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageString = viewModel!.photoListOutput.value[indexPath.row]
        self.topPhotoSelectView.setImage(Avatar.getImage(imageString))
        viewModel!.selectedPhoto.source(.next(imageString))
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.photoListOutput.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
        let selectedPhoto = viewModel!.photo
        let photo = viewModel!.photoListOutput.value[indexPath.row]
        cell.set(selectedPhoto == photo ? true : false, image: photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 4 - 16, height: UIScreen.main.bounds.width / 4 - 16)
    }

    
    final class PhotoCell: BaseCollectionViewCell, CellIdentifialble {
        private let photoView = PhotoSelectView(radius: (UIScreen.main.bounds.width / 4 - 16) / 2)
        
        override func addChild() {
            contentView.addSubview(photoView)
            photoView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        override func addLayout() {
            NSLayoutConstraint.activate([
                photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }

        func set(_ isSelected: Bool = true, image: String) {
            photoView.imageView.image = Avatar.getImage(image)
            photoView.imageView.alpha = isSelected ? 1.0 : 0.5
            photoView.imageView.layer.borderWidth = isSelected ? 3 : 1
            photoView.imageView.layer.borderColor =
            isSelected
            ?
            UIColor.validStateColor.cgColor
            :
            UIColor.disabledButtonColor.cgColor
        }
    }
}
