//
//  UIViewController+Extension.swift
//  UpDown
//
//  Created by hwan on 7/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit


extension UIViewController {
    var windowWidth: CGFloat {
        view.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    var windowHeight: CGFloat {
        view.window?.windowScene?.screen.bounds.height ?? UIScreen.main.bounds.height
    }
}

extension UIView {
    var windowWidth: CGFloat {
        self.window?.windowScene?.screen.bounds.width ?? UIScreen.main.bounds.width
    }
    var windowHeight: CGFloat {
        self.window?.windowScene?.screen.bounds.height ?? UIScreen.main.bounds.height
    }
}
