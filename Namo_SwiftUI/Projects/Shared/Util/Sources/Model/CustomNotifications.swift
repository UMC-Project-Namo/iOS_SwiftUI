//
//  CustomNotifications.swift
//  SharedUtil
//
//  Created by 박민서 on 10/20/24.
//

import SwiftUI

public enum NetworkErrorNotification {
    case refreshTokenExpired
    case unauthorized
    case tryLater
    
    public var title: String {
        switch self {
            
        case .refreshTokenExpired:
            return "토큰 만료"
        case .unauthorized:
            return "인증 필요"
        case .tryLater:
            return "네트워크 에러"
        }
    }
    
    public var content: String {
        switch self {
            
        case .refreshTokenExpired:
            return "토큰이 만료되었습니다. 다시 로그인해주세요."
        case .unauthorized:
            return "다시 로그인 해주세요."
        case .tryLater:
            return "네트워크 에러가 발생했습니다. 다시 시도해주세요."
        }
    }
}

public extension Notification.Name {
    static let networkError = Notification.Name("NetworkError")
}
