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
        public static let initialState = State(routes: [.root(.mainTab(.initialState), embedInNavigationView: true)], mainStore: .initialState, moimEditStore: .initialState)
        
        
        var routes: [Route<MoimScreen.State>]
        
        var isPresentedSheet: Bool = false
                
        var mainStore: MainViewStore.State
        
        var moimEditStore: MoimEditCoordinator.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case mainAction(MainViewStore.Action)
        case moimEditAction(MoimEditCoordinator.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.mainStore, action: \.mainAction) {
            MainViewStore()
        }
        Scope(state: \.moimEditStore, action: \.moimEditAction) {
            MoimEditCoordinator()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .mainTab(.moimListAction(.presentComposeSheet)))):
                state.isPresentedSheet = true
                state.routes.presentCover(.moimEdit(.initialState))
                return .none
            case .router(.routeAction(_, action: .moimEdit(.moimEditAction(.cancleButtonTapped)))):
                state.isPresentedSheet = false
                state.routes.dismiss()
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



