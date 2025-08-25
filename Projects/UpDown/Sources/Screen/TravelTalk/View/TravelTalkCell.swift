//
//  TravelTalkCell.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Kingfisher

final class TravelTalkCell: UICollectionViewCell, CellIdentifialble {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var conversationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 25
        profileImage.layer.borderWidth = 0.1
        profileImage.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    func configure(info room: ChatRoom) {
        profileImage.image = UIImage(named: "\(room.chatroomImage)") ?? ImageGen.star
        nickNameLabel.text = room.chatroomName
        
        conversationLabel.text
        = if let chat = room.chatList.last {
            chat.message
        } else {
            ""
        }
        
        dateLabel.text
        = if let chat = room.chatList.last {
            chat.date
                .toDate("yyyy-MM-dd HH:mm")?
                .toFormat("yy.MM.dd")
        } else {
            ""
        }
    }
}
