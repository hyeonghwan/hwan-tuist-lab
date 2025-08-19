//
//  TagModel.swift
//  PhotoFeature
//
//  Created by hwan on 8/16/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

struct TagModel: Equatable {
    let color: QueryColor
    var isSelected: Bool = false
    
    static var allCases: [Self] {
        QueryColor.allCases.map {
            TagModel(color: $0, isSelected: false)
        }
    }
}


enum QueryColor: String, CaseIterable {
    case black_and_white
    case black
    case white
    case yellow
    case orange
    case red
    case purple
    case magenta
    case green
    case teal
    case blue
    
    var title: String {
        return switch self {
        case .black_and_white:
            "블랙&화이트"
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .orange:
            "오랜지"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .magenta:
            "마젠타"
        case .green:
            "그린"
        case .teal:
            "틸"
        case .blue:
            "블루"
        }
    }
    
    var color: UIColor {
        return switch self {
        case .black_and_white:
            UIColor.gray
        case .black:
            UIColor.black
        case .white:
            UIColor.white
        case .yellow:
            UIColor.yellow
        case .orange:
            UIColor.orange
        case .red:
            UIColor.red
        case .purple:
            UIColor.purple
        case .magenta:
            UIColor.magenta
        case .green:
            UIColor.green
        case .teal:
            UIColor.systemTeal
        case .blue:
            UIColor.blue
        }
    }
}
