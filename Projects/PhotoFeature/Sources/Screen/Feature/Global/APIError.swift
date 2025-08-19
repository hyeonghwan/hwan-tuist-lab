//
//  Error.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation

enum APIError: Error, Hashable {
    case badRequest       // 400
    case unauthorized     // 401
    case forbidden        // 403
    case notFound         // 404
    case server           // 5xx
    case noInternet
    case unknown

    var message: String {
        switch self {
        case .badRequest:   return "요청이 올바르지 않습니다. 다시 시도해 주세요. (400)"
        case .unauthorized: return "인증 정보가 유효하지 않습니다. 다시 로그인해 주세요. (401)"
        case .forbidden:    return "요청 권한이 없습니다. (403)"
        case .notFound:     return "요청한 리소스를 찾을 수 없습니다. (404)"
        case .server:       return "서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요. (5xx)"
        case .noInternet:   return "인터넷 연결을 확인해 주세요."
        case .unknown:      return "알 수 없는 오류가 발생했습니다."
        }
    }
}

private extension TopicError {
    static func map(_ error: Error) -> TopicError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .timedOut, .cannotFindHost, .cannotConnectToHost:
                return .noInternet
            default:
                break
            }
        }
        let ns = error as NSError
        if let status = ns.userInfo["statusCode"] as? Int { // APIClient에서 넣어줬다는 가정
            switch status {
            case 400: return .badRequest
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 500...599: return .server
            default: break
            }
        }
        return .unknown
    }
}
