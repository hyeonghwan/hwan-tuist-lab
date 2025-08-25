//
//  CityCollectionCell.swift
//  City
//
//  Created by hwan on 7/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Kingfisher

final class CityCollectionCell: UICollectionViewCell, CellIdentifialble {

    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityListlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityImageView.kf.cancelDownloadTask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        cityImageView.layer.cornerRadius = cityImageView.bounds.width / 2
    }
    
    func set(info: City, contains: String?) {
        load(image: info.image)
        labelSetting(info: info, contains: contains)
    }
    
    private func load(image: String) {
        if let url = URL(string: image) {
            let size = CGSize(width: 200, height: 200)
            cityImageView.kf.downSizingImage(url: url, size: size)
        } else {
            cityImageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
    }
    
    private func labelSetting(info: City, contains: String?) {
        self.cityNameLabel.attributedText = makeCityName(info: info, contains: contains)
        self.cityListlabel.attributedText = makeCityList(info: info, contains: contains)
    }
    
    private func makeCityName(info: City, contains: String?) -> NSAttributedString {
        if let contains {
            let nameText = NSMutableAttributedString()
            nameText.append(info.name.highlightKeyword(contains))
            nameText.append(NSAttributedString(string: " | "))
            nameText.append(info.enName.highlightKeyword(contains))
            return nameText
        } else {
            return NSAttributedString(string: "\(info.name) | \(info.enName)")
        }
    }
    
    private func makeCityList(info: City, contains: String?) -> NSAttributedString {
        if let contains {
            let listText = NSMutableAttributedString()
            for (index, text) in info.explain.enumerated() {
                listText.append(text.highlightKeyword(contains))
                if index != info.explain.count - 1 {
                    listText.append(.separator)
                }
            }
            return listText
        } else {
            return NSAttributedString(string: info.explain.joined(separator: ", "))
        }
    }
}
