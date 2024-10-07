//
//  SplashCoordinator.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import SharedUtil

/// 유저의 현재 상태를 분류합니다
enum UserStatus {
    /// 로그인 X
    case logout
    /// 로그인 + 추가 정보 미입력
    case loginWithoutEverything
    /// 로그인, 약관동의 정보 필요
    case loginWithoutAgreement
    /// 로그인, 유저 정보 필요
    case loginWithoutUserInfo
    /// 로그인 + 모든 정보 입력
    case loginWithAll
}

@Reducer
struct SplashCoordinator {
    @Dependency(\.authClient) var authClient
    
    struct State: Equatable {
        /// 로그인 여부
        var isLogin: Bool = false
        /// 약관 동의 여부
        var agreementCompleted: Bool?
        /// 회원 정보 작성 여부
        var userInfoCompleted: Bool?
    }
    
    enum Action {
        // 로그인 체크
        case loginCheck
        // 로그인 화면
        case goToLoginScreen
        // 온보딩 처음 화면
        case goToOnboardingScreen
        // 약관 동의 화면
        case goToAgreementScreen
        // 유저 정보 작성 화면
        case goToUserInfoScreen
        // 메인 화면
        case goToMainScreen
    }
    
    var body: some ReducerOf<Self> {
        
        
        Reduce<State, Action> { state, action in
            switch action {
            case .loginCheck:
                
                switch userStatusCheck() {
                    
                case .logout:
                    return .send(.goToLoginScreen)
                case .loginWithoutEverything:
                    return .send(.goToOnboardingScreen)
                case .loginWithoutAgreement:
                    return .send(.goToAgreementScreen)
                case .loginWithoutUserInfo:
                    return .send(.goToUserInfoScreen)
                case .loginWithAll:
                    return .send(.goToMainScreen)
                }
                
//                if authClient.getLoginState() != nil {
//                    return .send(.goToMainScreen)
//                } else {
//                    return .send(.goToOnboardingScreen)
//                }
                
//                로그아웃은 임시로 해당 주석을 풀어서 사용해주세요
//                return .run { send in
//                    await authClient.setLogoutState(with: .apple)
//                    await send(.goToOnboardingScreen)
//                }
            default:
                return .none
            }
        }
    }
    /// 유저의 현재 상태를 파악합니다
    func userStatusCheck() -> UserStatus {
        // 로그인 상태 확인
        guard let isLogin = authClient.getLoginState() else { return .logout}
        // 약관 동의 여부 nil 체크
        guard let agreementCompleted = authClient.getAgreementCompletedState() else { return .loginWithoutAgreement }
        // 유저 정보 작성 여부 nil 체크
        guard let userInfoCompleted = authClient.getUserInfoCompletedState() else { return .loginWithoutUserInfo }
        // 필요 정보 작성 여부 체크
        guard agreementCompleted && userInfoCompleted else { return .loginWithoutEverything }
        
        return .loginWithAll
    }
}
