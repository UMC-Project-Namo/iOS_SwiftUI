//
//  AuthInterceptor.swift
//  Namo_SwiftUI
//
//  Created by 박민서 on 1/30/24.
//

import Alamofire
import Foundation
import Factory
import NaverThirdPartyLogin

import SharedUtil

/// API Request의 Authentication을 관리합니다.
public class AuthInterceptor: RequestInterceptor {
    
    /// 요청 실패 시 재시도 횟수입니다.
    private var retryLimit = 2
    
    /// URLRequest를 보내는 과정을 Intercept하여, Request의 내용을 변경합니다.
    ///
    /// - Parameters:
    ///    - urlRequest: 원래의 URLRequest
    ///    - session : 진행하는 Alamofire Session
    ///    - completion: 변경된 URLRequest를 포함하는 Result를 비동기 처리하는 클로저
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // baseURL 확인
        guard urlRequest.url?.absoluteString.hasPrefix(SecretConstants.baseURL) == true else { return }
        
        do {
            // accessToken 조회
            let accessToken = try KeyChainManager.readItem(key: "accessToken")
            
            // URLRequest 헤더 추가
            var urlRequest = urlRequest
            urlRequest.headers.add(.authorization("Bearer \(accessToken)"))
            
            // URLRequest 반환
            completion(.success(urlRequest))
        } catch {
            // unauthorized noti post -> AppCoordi
            NotificationCenter.default.post(name: .networkError, object: nil, userInfo: ["error": NetworkErrorNotification.unauthorized])
            // 조회 실패 결과 반환
            completion(.failure(APIError.customError("[AuthManager] 키체인 토큰 조회 실패. 로그인이 필요합니다. (adapt)")))
        }
    }
    
    /// Request 요청이 실패했을 때, 재시도 여부를 결정합니다.
    ///
    /// - Parameters:
    ///     - request: 실패한 원래 Request
    ///     - session: 진행하던 Alamofire Session
    ///     - error: 실패 원인의 error
    ///     - completion: RetryResult를 처리하여 재시도 여부를 알려주는 비동기 클로저
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("=======retry 호출됨========")
        // HTTP 상태 코드가 401 (Unauthorized)일 경우
        if let response = request.response, response.statusCode == 401 {
            // unauthorized noti post -> AppCoordi
            NotificationCenter.default.post(name: .networkError, object: nil, userInfo: ["error": NetworkErrorNotification.unauthorized])
            completion(.doNotRetry)
            return
        }
        
        if request.retryCount < self.retryLimit {
            print("기존 요청 재시도 : \(request.request?.url?.absoluteString ?? "url_nil")")
            completion(.retry)
        } else {
            // tryLater noti post -> AppCoordi
            NotificationCenter.default.post(name: .networkError, object: nil, userInfo: ["error": NetworkErrorNotification.tryLater])
            completion(.doNotRetry)
        }
        
    }
}
