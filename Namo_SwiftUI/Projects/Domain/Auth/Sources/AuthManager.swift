//
//  AuthManager.swift
//  CoreNetwork
//
//  Created by 박민서 on 10/4/24.
//

import Foundation
import SharedUtil
import Core
import ComposableArchitecture
import DomainAuthInterface

/// 로그인, 로그아웃 및 유저 인증 관련 상태를 관리하는 매니저입니다.
/// 유저 관련 UserDefaults 세팅은 여기에서 관리됩니다.
/// - 의존성:
///   - `authClient`를 사용하여 로그아웃 및 로그인 API 요청을 처리합니다.
public struct AuthManager: AuthManagerProtocol {
    
    // MARK: 추후 문제시 init에서 의존성 주입으로 변경
    @Dependency(\.authClient) var authClient
    
    public init() {}
    
    /// 유저의 현재 상태를 파악합니다
    public func userStatusCheck() -> UserStatus {
        // 로그인 상태 확인
        guard let _ = authClient.getLoginState() else { return .logout }
        // 약관 동의 여부 nil 체크
        guard let agreementCompleted = authClient.getAgreementCompletedState() else { return .loginWithoutAgreement }
        // 유저 정보 작성 여부 nil 체크
        guard let userInfoCompleted = authClient.getUserInfoCompletedState() else { return .loginWithoutUserInfo }
        // 필요 정보 작성 여부 체크
        guard agreementCompleted && userInfoCompleted else { return .loginWithoutEverything }
        
        return .loginWithAll
    }
    
    /// 저장된 유저 정보를 삭제합니다
    public func deleteUserInfo() {
        do {
            try KeyChainManager.deleteItem(key: "accessToken")
            try KeyChainManager.deleteItem(key: "refreshToken")
            try KeyChainManager.deleteItem(key: "userId")
            self.deleteSocialLoginType()
            self.deleteAgreementCompletedState()
            self.deleteUserInfoCompletedState()
        } catch {
            print("임시 처리: \(error.localizedDescription)")
        }
    }
}

// MARK: Login/Logout Extension
public extension AuthManager {
    /// 로그인 상태 가져오기
    /// 소셜 로그인 상태 없거나 토큰 없는 경우 nil 반환
    func getLoginState() -> OAuthType? {
        // 소셜 로그인 상태
        guard let socialLoginType = getSocialLoginType() else { return nil }
        // 토큰 존재 여부
        do {
            _ = try KeyChainManager.readItem(key: "accessToken")
            _ = try KeyChainManager.readItem(key: "refreshToken")
        } catch {
            return nil
        }
        return socialLoginType
    }
        
    /// 카카오/네이버/애플 로그인 상태 저장
    func setLoginState(_ oAuthType: OAuthType, with result: SignInResponseDTO) {
        // TODO: 로그인 상태 관련 UI 처리 작업 필요한 지 확인
        do {
            // 1. socialLogin 상태 저장
            setSocialLoginType(oAuthType)
            
            // 2. tokens 키체인 저장
            try KeyChainManager.addItem(key: "accessToken", value: result.accessToken)
            try KeyChainManager.addItem(key: "refreshToken", value: result.refreshToken)
            
            // 3. userId 키체인 저장
            
            try KeyChainManager.addItem(key: "userId", value: String(result.userId))
            
            // 4. 약관 동의, 필요 정보 작성 여부 저장
            let termAgreement = result.terms.reduce(true) { $0 && $1.check }
            self.setAgreementCompletedState(termAgreement)
            self.setUserInfoCompletedState(result.signUpComplete)
            
            print("!---로그인 처리 완료---!")
        } catch {
            // 에러 처리
            print("임시 처리: \(error.localizedDescription)")
        }
    }
    
    /// 카카오/네이버/애플 로그아웃 상태 저장
    func setLogoutState() async {
        // TODO: 로그인 상태 관련 UI 처리 작업 필요한 지 확인
        do {
            // 1. get loginType
            guard let oAuthType = getLoginState() else { throw NSError(domain: "로그인 상태 로딩 실패", code: 1001) }
            
            // 2. get refreshToken
            let refreshToken: String = try KeyChainManager.readItem(key: "refreshToken")
            
            // 3. 나모 로그아웃 API 호출
            try await authClient.reqSignOut(LogoutRequestDTO(refreshToken: refreshToken))
            
            // 4. 소셜 로그인 타입별 로그아웃 진행
            switch oAuthType {
                
            case .kakao:
                await authClient.kakaoLogout()
            case .naver:
                await authClient.naverLogout()
            case .apple:
                return
            }
            
            // 5. 유저 정보 삭제
            deleteUserInfo()
            
            print("!---로그아웃 완료---!")
        } catch {
            // 에러 처리
            print("임시 처리: \(error.localizedDescription)")
        }
    }
}

// MARK: Withdraw Extension
public extension AuthManager {
    /// OAuthType별 회원탈퇴 처리
    func withdraw() async {
        do {
            guard let oAuthType = getLoginState() else { throw NSError(domain: "로그인 상태 로딩 실패", code: 1001) }
            
            let refreshToken: String = try KeyChainManager.readItem(key: "refreshToken")
            
            switch oAuthType {
                
            case .kakao:
                try await authClient.reqWithdrawalKakao(LogoutRequestDTO(refreshToken: refreshToken))
            case .naver:
                try await authClient.reqWithdrawalNaver(LogoutRequestDTO(refreshToken: refreshToken))
            case .apple:
                try await authClient.reqWithdrawalApple(LogoutRequestDTO(refreshToken: refreshToken))
            }
            
            deleteUserInfo()
            
            print("!---회원 탈퇴 완료---!")
        } catch {
            // 에러 처리
            print("임시 처리: \(error.localizedDescription)")
        }
    }
}

// MARK: Agreement Extension
public extension AuthManager {
    /// 약관 동의 상태 가져오기
    /// 저장된 값이 없는 경우 nil 반환
    func getAgreementCompletedState() -> Bool? {
        guard let isAgreementCompleted = UserDefaults.standard.value(forKey: "isAgreementCompleted") as? Bool else { return nil }
        return isAgreementCompleted
    }
    
    /// 약관 동의 상태 저장
    func setAgreementCompletedState(_ isCompleted: Bool) {
        UserDefaults.standard.set(isCompleted, forKey: "isAgreementCompleted")
    }
    
    /// 약관 동의 상태 제거
    func deleteAgreementCompletedState() {
        UserDefaults.standard.removeObject(forKey: "isAgreementCompleted")
    }
}

// MARK: User Info Extension
public extension AuthManager {
    /// 회원 가입 유저 정보 작성 상태 가져오기
    /// 저장된 값이 없는 경우 nil 반환
    func getUserInfoCompletedState() -> Bool? {
        guard let isUserInfoCompleted = UserDefaults.standard.value(forKey: "isUserInfoCompleted") as? Bool else { return nil }
        return isUserInfoCompleted
    }
    /// 회원 가입 유저 정보 작성 상태 저장
    func setUserInfoCompletedState(_ isCompleted: Bool) {
        UserDefaults.standard.set(isCompleted, forKey: "isUserInfoCompleted")
    }
    
    /// 회원 가입 유저 정보 작성 상태 제거
    func deleteUserInfoCompletedState() {
        UserDefaults.standard.removeObject(forKey: "isUserInfoCompleted")
    }
}

// MARK: Social Login Type Extension
public extension AuthManager {
    /// 소셜 로그인 타입 가져오기
    /// 저장된 값이 없는 경우 nil 반환
    func getSocialLoginType() -> OAuthType? {
        guard let socialLoginType = UserDefaults.standard.string(forKey: "socialLogin") else { return nil }
        return  OAuthType(rawValue: socialLoginType)
    }
    
    /// 소셜 로그인 타입 저장
    func setSocialLoginType(_ oAuthType: OAuthType) {
        UserDefaults.standard.set(oAuthType.rawValue, forKey: "socialLogin")
    }
    
    /// 소셜 로그인 타입 제거
    func deleteSocialLoginType() {
        UserDefaults.standard.removeObject(forKey: "socialLogin")
    }
}
