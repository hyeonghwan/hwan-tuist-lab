//
//  NumberCell.swift
//  UpDown
//
//  Created by hwan on 7/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

protocol CellIdentifialble {
    static var id: String { get }
}

extension CellIdentifialble {
    static var id: String {
        String(describing: Self.self)
    }
}

final class NumberCell: UICollectionViewCell, CellIdentifialble {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.backgroundColor = .white
        self.numberLabel.textColor = .black
    }
    
    func configure(model: GameViewModel) {
        self.numberLabel.text = "\(model.item)"
        self.contentView.backgroundColor = model.selected ? .black : .white
        self.numberLabel.textColor = model.selected ? .white : .black
    }
}
