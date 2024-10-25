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

@Reducer(state: .equatable)
public enum MoimScreen {
    // 모임 일정
    case moimSchedule(MainViewStore)
    // 모임/친구 요청
    case moimRequest(MoimRequestStore)
}

@Reducer
public struct MoimCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.moimSchedule(.initialState), embedInNavigationView: true)],
                                               moimSchedule: .initialState,
                                               moimRequest: .init()
        )
        
        var routes: [Route<MoimScreen.State>]
        var moimSchedule: MainViewStore.State
        var moimRequest: MoimRequestStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case moimSchedule(MainViewStore.Action)
        case moimRequest(MoimRequestStore.Action)
        case placeSearch(PlaceSearchStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimSchedule, action: \.moimSchedule) {
            MainViewStore()
        }
        Scope(state: \.moimRequest, action: \.moimRequest) {
            MoimRequestStore()
        }        
        
        Reduce<State, Action> { state, action in
            switch action {
                // 모임 요청
            case .router(.routeAction(_, action: .moimSchedule(.notificationButtonTap))):
                state.routes.push(.moimRequest(.init()))
                return .none
                // 화면 제거
            case .router(.routeAction(_, action: .moimRequest(.backButtonTap))):
                state.routes.goBack()
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



