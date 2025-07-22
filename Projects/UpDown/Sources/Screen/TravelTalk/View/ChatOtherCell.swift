//
//  ChatOtherCell.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

final class ChatOtherCell: UICollectionViewCell, CellIdentifialble, ChatCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var viewAllLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    @IBOutlet weak var topSpacingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var spacingToContent: NSLayoutConstraint!
    @IBOutlet weak var labelTopSpacing: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingSpacing: NSLayoutConstraint!
    @IBOutlet weak var labelBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var contentBottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingSpacing: NSLayoutConstraint!
    @IBOutlet weak var imageSpacingToNickname: NSLayoutConstraint!
    @IBOutlet weak var dateToMessageSpacing: NSLayoutConstraint!
    @IBOutlet weak var dateToTrailingSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var bottomLabelButtonSpacing: NSLayoutConstraint!
    
    // MARK: labelTopSpacing 은 labelLeading Trailing Spacing과 똑같음
    private var cellWithoutMessageWidth: CGFloat {
        imageLeadingSpacing.constant +
        imageWidth.constant +
        imageSpacingToNickname.constant +
        labelLeadingSpacing.constant * 2 +
        dateToMessageSpacing.constant +
        dateToTrailingSpacing.constant
    }
    
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
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.borderWidth = 0.1
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.clipsToBounds = true
        
        contentContainerView.layer.cornerRadius = 12
        contentContainerView.clipsToBounds = true
        contentContainerView.layer.borderWidth = 1
        contentContainerView.layer.borderColor = UIColor.systemGray6.cgColor
        
        viewAllLabel.isHidden = true
        viewAllButton.isHidden = true
    }
    
    func configure(info model: ChatViewModel) {
        let chat = model.chat
        profileImageView.image = UIImage(named: chat.user.image)
        nickNameLabel.text = chat.user.name
        dateLabel.text = chat.date
            .toDate("yyyy-MM-dd HH:mm")?
            .toFormat("hh:mm a")
        contentLabel.text = "\(chat.message)"
        
        let isTruncated = model.isTruncated
        
        if let isTruncated {
            labelBottomSpacing.constant = isTruncated
            viewAllLabel.isHidden = false
            viewAllButton.isHidden = false
            bottomLabelButtonSpacing.constant = 120
            bottomLabelButtonSpacing.priority = .defaultHigh
        } else {
            labelBottomSpacing.constant = labelTopSpacing.constant
            viewAllLabel.isHidden = true
            viewAllButton.isHidden = true
            bottomLabelButtonSpacing.constant = 0
            bottomLabelButtonSpacing.priority = .defaultLow
        }
    }
    
    func layoutHeightFitting() -> (height: CGFloat, isTruncated: CGFloat?) {
        let nicknameLabelHeight = nickNameLabel.systemLayoutSizeFitting(
            CGSize(width: 100, height: 25)
        ).height
        
        let dateLabelSize = dateLabel.sizeThatFits(CGSize(width: 80, height: 20))
        let estimatedWidth = windowWidth - (cellWithoutMessageWidth + dateLabelSize.width)
        
        let contentLabelHeight = contentLabel.systemLayoutSizeFitting(
            CGSize(width: estimatedWidth, height: 500),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        let totalHeight = topSpacingConstraint.constant +
        spacingToContent.constant +
        labelTopSpacing.constant +
        labelBottomSpacing.constant +
        contentBottomSpacing.constant +
        nicknameLabelHeight +
        contentLabelHeight
        
        let isTruncated = contentLabel.isTruncated(
            width: estimatedWidth,
            height: contentLabelHeight
        )
        
        let bottom: CGFloat = 8
        let height = viewAllLabel.sizeThatFits(CGSize(width: 60, height: 20)).height
        let bottomViewHeight = bottom + height + 8
        
        if isTruncated {
            return (totalHeight + bottomViewHeight, bottomViewHeight)
        } else {
            return (totalHeight, nil)
        }
    }
}
