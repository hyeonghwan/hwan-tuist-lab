//
//  ChatCell.swift
//  UpDown
//
//  Created by hwan on 7/20/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

protocol ChatCell: AnyObject {
    var contentContainerView: UIView! { get }
    func configure(info model: ChatViewModel)
    func layoutHeightFitting(_ viewModel: ChatViewModel) -> (height: CGFloat, isTruncated: CGFloat?)
}
