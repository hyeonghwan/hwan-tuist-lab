//
//  BaseVC+ErrorHandler.swift
//  NetworkSample
//
//  Created by hwan on 7/29/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit
import Design

extension BaseViewController {
    func showFallBackAlert(_ error: Error, retry: @escaping () -> Void, confirm: @escaping () -> Void) {
        let retry = AlertAction(text: "재시도", color: .red) {
            retry()
        }
        
        let ok = AlertAction(text: "확인", color: .black) {
            confirm()
        }
        
        var (title, message): (String, String) = ("에러", "관리자에게 문의 해주세요")
        
        if let apiError = error as? NaverApiError {
            message = apiError.alertMessage
        } else if let (_title, _message) = convertToURLError(error: error) {
            title = _title
            message = _message
        }
        
        self.showAlert(
            title: title,
            message: message,
            action: retry, ok
        )
    }
    
    private func convertToURLError(error: Error) -> (title: String, message: String)? {
        if let AFError = error.asAFError {
            let title: String = "네트워크 에러"
            var message: String = "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
            switch AFError {
            case let .sessionTaskFailed(error: error):
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        message = "인터넷에 연결되어 있지 않습니다.\n Wi-Fi 또는 데이터 연결을 확인해주세요."
                        
                    case .timedOut:
                        message = "서버 응답이 지연되고 있습니다.\n잠시 후 다시 시도해주세요."
                        
                    case .cannotFindHost, .cannotConnectToHost:
                        message = "서버에 연결할 수 없습니다.\n 잠시 후 다시 시도해주세요."
                        
                    case .networkConnectionLost:
                        message = "네트워크 연결이 끊어졌습니다.\n 연결 상태를 확인하고 다시 시도해주세요."
                        
                    case .cancelled:
                        return nil
                        
                    default:
                        message = "일시적인 네트워크 오류가 발생했습니다.\n 잠시 후 다시 시도해주세요."
                    }
                    return (title, message)
                }
            default:
                return (title, message)
            }
        }
        
        if let apiError = error as? NaverApiError {
            debugPrint("apiError: \(apiError) , message: \(apiError.message)")
            return ("내부 에러", apiError.alertMessage)
        }
        
        return ("시스템 에러", NaverApiError.unknown.alertMessage)
    }
}

