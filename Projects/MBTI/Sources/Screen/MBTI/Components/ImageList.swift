//
//  ImageList.swift
//  MBTI
//
//  Created by hwan on 8/14/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

enum Avatar: String, CaseIterable {
    case boy
    case dog
    case girl
    case giraffe
    case man
    case profile
    case rabbit
    case woman
    
    static func getRandomAvatarString() -> String {
        Avatar.allCases.randomElement()!.rawValue
    }
    
    static func getImage(_ name: String) -> UIImage {
        UIImage(named: name)!
    }
}
