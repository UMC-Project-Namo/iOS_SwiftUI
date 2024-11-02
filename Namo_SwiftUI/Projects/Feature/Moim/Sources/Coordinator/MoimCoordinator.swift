//
//  MoimCoordinator.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/21/24.
//

import Foundation

import ComposableArchitecture
import TCACoordinators

import FeaturePlaceSearchInterface
import FeatureMoimInterface
import FeatureFriend

@Reducer(state: .equatable)
public enum MoimScreen {
    case mainTab(MainViewStore)
    case moimEdit(MoimEditCoordinator)
    case notification
}

@Reducer
public struct MoimCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.mainTab(.initialState), embedInNavigationView: true)], mainTabStore: .initialState)
        
        
        var routes: [Route<MoimScreen.State>]
        
        var isPresentedSheet: Bool = false
                        
        var mainTabStore: MainViewStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case mainTabAction(MainViewStore.Action)
    }
    
    public var body: some ReducerOf<Self> {        
        Scope(state: \.mainTabStore, action: \.mainTabAction) {
            MainViewStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {            
            /// 일정 생성
            case .router(.routeAction(_, action: .mainTab(.moimListAction(.presentComposeSheet)))):
                state.isPresentedSheet = true
                state.routes.presentCover(.moimEdit(.init()))
                return .none
            /// 일정 조회
            case let .router(.routeAction(_, action: .mainTab(.moimListAction(.presentDetailSheet(moimSchedule))))):
                state.routes.presentCover(.moimEdit(.init(moimEditStore: .init(moimSchedule: moimSchedule))))
                state.isPresentedSheet = true
                return .none
            /// 완료 또는 취소 작업
            case .router(.routeAction(_, action: .moimEdit(.moimEditAction(.cancleButtonTapped)))):
                state.isPresentedSheet = false
                state.routes.dismiss()
                return .none
            /// 친구 요청
            case .router(.routeAction(_, action: .mainTab(.notificationButtonTap))):
                state.routes.push(.notification)
                return .none            
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



