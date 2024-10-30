//
//  AppCoordinator.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import SharedUtil

@Reducer(state: .equatable)
enum AppScreen {
    // 메인탭
    case mainTab(MainTabCoordinator)
    // 온보딩
    case onboarding(OnboardingCoordinator)
}

@Reducer
struct AppCoordinator {
    
    @Dependency(\.authClient) var authClient
    
    @ObservableState
    struct State {
        static let initialState = State(routes: [.root(.onboarding(.initialState), embedInNavigationView: true)])
        var routes: [Route<AppScreen.State>]
        var showAlert: Bool = false
        var alertTitle: String = ""
        var alertContent: String = ""
        var alertConfirmAction: AppCoordinator.Action = .goToInitialScreen
    }
    
    enum Action {
        case router(IndexedRouterActionOf<AppScreen>)
        case changeShowAlert(show: Bool)
        indirect case setAlert(title: String, content: String, action: AppCoordinator.Action)
        case handleNotiError(error: NetworkErrorNotification)
        case doAlertConfirmAction
        case goToInitialScreen
        case doNothing
    }
    
    var body: some ReducerOf<Self> {
        
        Reduce<State, Action> { state, action in

            switch action {
                
            // mainTab 이동 - 로그인 체크 결과 goToMainScreen 시
            case .router(.routeAction(_, action: .onboarding(.goToMainScreen))):
                state.routes = [.root(.mainTab(.init(home: .initialState, moim: .initialState)), embedInNavigationView: true)]
                return .none
                
            // Notification 에러 핸들링
            case .handleNotiError(let error):
                switch error {
                    
                    // 리프레쉬 토큰 만료 - 정보 삭제
                case .refreshTokenExpired, .unauthorized:
                    authClient.deleteUserInfo()
                    return .send(.setAlert(title: error.title, content: error.content, action: .goToInitialScreen))
                    // 네트워크 에러 - 라우팅 x
                case .tryLater:
                    return .send(.setAlert(title: error.title, content: error.content, action: .doNothing))
                }
            
            // alert 내용 설정
            case let .setAlert(title, content, action):
                state.alertTitle = title
                state.alertContent = content
                state.alertConfirmAction = action
                return .send(.changeShowAlert(show: true))
            
            // alert 표시 변경
            case .changeShowAlert(let show):
                state.showAlert = show
                return .none
            
            // alertConfirmAction 실행
            case .doAlertConfirmAction:
                return .send(state.alertConfirmAction)
                
            // 초기 화면으로 이동
            case .goToInitialScreen:
                state = State.initialState
                return .none
                
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

