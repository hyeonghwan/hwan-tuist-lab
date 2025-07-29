//
//  ChatDetailViewController.swift
//  UpDown
//
//  Created by hwan on 7/20/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
 

  
final class ChatDetailViewController: UIViewController, CellIdentifialble {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spacing: CGFloat = 16
        contentTextView.textContainerInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.contentTextView.text = text
        // logger.log(level: .debug, "\(#function)")
    }
}
