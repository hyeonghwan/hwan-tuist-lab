//
//  ChatMeCell.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class ChatMeCell: UICollectionViewCell, CellIdentifialble, ChatCell {
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var bottomLabelButtonSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var messageContentSpacing: NSLayoutConstraint!
    @IBOutlet weak var messageContainerSpacing: NSLayoutConstraint!
    @IBOutlet weak var dateContentSpacing: NSLayoutConstraint!
    @IBOutlet weak var dateLabelContainerSpacing: NSLayoutConstraint!
    @IBOutlet weak var contentTrailingSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var labelBottomSpacing: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        contentContainerView.layer.cornerRadius = 12
        contentContainerView.layer.borderWidth = 1
        contentContainerView.layer.borderColor = UIColor.systemGray6.cgColor
        viewAllLabel.isHidden = true
        viewAllButton.isHidden = true
    }
    
    func configure(info model: ChatViewModel) {
        dateLabel.text = model.chat.date
            .toDate("yyyy-MM-dd HH:mm")?
            .toFormat("hh:mm a")
        contentLabel.text = "\(model.chat.message)"
        
        let isTruncated = model.isTruncated
        
        if let isTruncated {
            labelBottomSpacing.constant = isTruncated
            viewAllLabel.isHidden = false
            viewAllButton.isHidden = false
            bottomLabelButtonSpacing.constant = 120
            bottomLabelButtonSpacing.priority = .defaultHigh
        } else {
            labelBottomSpacing.constant = 12
            viewAllLabel.isHidden = true
            viewAllButton.isHidden = true
            bottomLabelButtonSpacing.constant = 0
            bottomLabelButtonSpacing.priority = .defaultLow
        }
    }
    
    func layoutHeightFitting() -> (height: CGFloat, isTruncated: CGFloat?) {
        let dateLabelSize = dateLabel.sizeThatFits(CGSize(width: 100, height: 30))
        
        let width: CGFloat =
        dateLabelSize.width +
        messageContentSpacing.constant * 2 +
        dateContentSpacing.constant +
        dateLabelContainerSpacing.constant +
        contentTrailingSpacing.constant
        
        let estimatedWidth: CGFloat = windowWidth - width
        
        let contentLabelHeight = contentLabel.systemLayoutSizeFitting(
            CGSize(width: estimatedWidth, height: 300),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        let isTruncated = contentLabel.isTruncated(
            width: estimatedWidth,
            height: contentLabelHeight
        )
        let bottom: CGFloat = 8
        let height = viewAllLabel.sizeThatFits(CGSize(width: 60, height: 20)).height
        let bottomViewHeight = bottom + height + 8
        
        var totalHeight: CGFloat
        =
        contentLabelHeight +
        messageContentSpacing.constant * 2 +
        messageContainerSpacing.constant * 2
        
        if isTruncated {
            totalHeight += bottomViewHeight
            return (totalHeight, bottomViewHeight)
        } else {
            return (totalHeight, nil)
        }
    }
}
