//
//  String+extension.swift
//  UpDown
//
//  Created by hwan on 7/20/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

extension String {
    var isNotEmpty: Bool { !isEmpty }
    var space: Self { " " }
    var empty: Self { "" }
    
    
    func removeAllWhitespace() -> String {
        self.components(separatedBy: .whitespacesAndNewlines).joined()
    }
}
