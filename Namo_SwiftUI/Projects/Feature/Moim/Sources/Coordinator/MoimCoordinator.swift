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
        public static let initialState = State(routes: [.root(.mainTab(.initialState), embedInNavigationView: true)], mainStore: .initialState)
        
        
        var routes: [Route<MoimScreen.State>]
        
        var mainStore: MainViewStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case mainAction(MainViewStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.mainStore, action: \.mainAction) {
            MainViewStore()
        }     
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .mainTab(.moimListAction(.presentComposeSheet)))):
                state.routes.presentCover(.moimEdit(.initialState))
                return .none
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



