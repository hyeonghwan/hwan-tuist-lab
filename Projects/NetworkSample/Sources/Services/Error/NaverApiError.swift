//
//  NaverAPIError.swift
//  NetworkSample
//
//  Created by hwan on 7/25/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

enum APIError: Error {
    case decodingError(String)
}

struct NaverSearchAPIError: Decodable {
    let errorMessage: String
    let errorCode: NaverApiError
}

enum NaverApiError: String, Error, Decodable {
    case INCORRECT_QUERY = "SE01"
    case INVALID_DISPLAY_VALUE = "SE02"
    case INVALID_START_VALUE = "SE03"
    case INVALID_SORT_VALUE = "SE04"
    case MALFORMED_ENCODING = "SE06"
    case INVALID_SEARCH_API = "SE05"
    case SYSTEM_ERROR = "SE99"
    
    var message: String {
        switch self {
        case .INCORRECT_QUERY:
            return "잘못된 쿼리요청입니다."
        case .INVALID_DISPLAY_VALUE:
            return "부적절한 display 값입니다."
        case .INVALID_START_VALUE:
            return "부적절한 start 값입니다."
        case .INVALID_SORT_VALUE:
            return "부적절한 sort 값입니다."
        case .MALFORMED_ENCODING:
            return "잘못된 형식의 인코딩입니다."
        case .INVALID_SEARCH_API:
            return "존재하지 않는 검색 api 입니다."
        case .SYSTEM_ERROR:
            return "시스템 에러"
        }
    }
}
