//
//  CityDetailViewController.swift
//  Travel
//
//  Created by hwan on 7/17/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

final class CityDetailViewController: UIViewController, VCIdentifiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var explainLabel: UILabel!
    var information: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.layer.cornerRadius = 12
        titleLabel.text = "\(String(describing: information?.name ?? "")) | \(String(describing: information?.enName ?? ""))"
        explainLabel.text = information?.explain.joined(separator: ", ")
        
        if let url = URL(string: information?.image ?? "") {
            let size = CGSize(width: UIScreen.main.bounds.width, height: 300)
            cityImageView.kf.downSizingImage(url: url, size: size)
        } else {
            cityImageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
    }
}
