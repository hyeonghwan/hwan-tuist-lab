//
//  Error.swift
//  PhotoFeature
//
//  Created by hwan on 8/19/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import Foundation
import Alamofire

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
        case .forbidden:    return "API limit를 초과하였습니다. 잠시후에 다시시도 해주세요. (403)"
        case .notFound:     return "요청한 리소스를 찾을 수 없습니다. (404)"
        case .server:       return "서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요. (5xx)"
        case .noInternet:   return "인터넷 연결을 확인해 주세요."
        case .unknown:      return "알 수 없는 오류가 발생했습니다."
        }
    }
}

extension APIError {
    static func map(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .timedOut, .cannotFindHost, .cannotConnectToHost:
                return .noInternet
            default:
                break
            }
        }
        if let afError = error as? AFError {
            switch afError {
            case let .responseValidationFailed(reason: reson):
                if case let .unacceptableStatusCode(code: code) = reson {
                    return from(statusCode: code)
                }
            default:
                return .unknown
            }
        }
        return .unknown
    }
    
    private static func from(statusCode: Int) -> APIError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 500...599: return .server
        default: return .unknown
        }
    }
}
