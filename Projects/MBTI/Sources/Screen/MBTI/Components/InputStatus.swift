//
//  InputStatus.swift
//  MBTI
//
//  Created by hwan on 8/13/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit

enum InputStatus: String {
    case inValidLength  = "2글자 이상 10글자 미만으로 설정해주세요"
    case invalidSymbol  = "닉네임에 특수문자는 포함할 수 없어요"
    case containNumeric = "닉네임에 숫자는 포함할 수 없어요"
    case valid          = "사용할 수 있는 닉네임 입니다."
    case none           = ""
    
    var color: UIColor {
        switch self {
        case .inValidLength, .invalidSymbol, .containNumeric:
            return .invalidStateColor
        case .valid:
            return .validStateColor
        case .none:
            return .label
        }
    }
    
    static let set = Set<Character>(Array("\\|[]{}-!@#$%^&*()_+-=,.:';'\"`~"))
    
    static func validate(_ text: String) -> (String, InputStatus) {
        let notValidLength = 2 > text.count || 10 <= text.count
        if notValidLength {
            return (text, InputStatus.inValidLength)
        }
        if text.contains(where: { char in set.contains(char) }) {
            return (text, InputStatus.invalidSymbol)
        }
        
        if text.contains(where: \.isNumber) {
            return (text, InputStatus.containNumeric)
        }
        return (text, InputStatus.valid)
    }
}
