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
    case main(MainViewStore)
    case moimEdit(MoimEditStore)
    case kakaoMap
    case notification
}

@Reducer
public struct MoimCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.main(.initialState), embedInNavigationView: true)], mainStore: .initialState)
        
        
        var routes: [Route<MoimScreen.State>]
        
        var mainStore: MainViewStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case mainAction(MoimEditStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.mainStore.moimEditStore, action: \.mainAction) {
            MoimEditStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .main(.moimListAction(.presentComposeSheet)))):                
                state.routes.presentCover(.moimEdit(.init()), embedInNavigationView: false)
                return .none
            case .router(.routeAction(_, action: .moimEdit(.goToKakaoMapView))):
                state.routes.push(.kakaoMap)
                return .none
            case .router(.routeAction(_, action: .main(.notificationButtonTap))):
                state.routes.push(.notification)
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



