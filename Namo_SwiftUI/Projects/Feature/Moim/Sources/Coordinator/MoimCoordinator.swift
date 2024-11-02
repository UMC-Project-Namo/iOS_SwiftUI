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
        public static let initialState = State(routes: [.root(.mainTab(.initialState), embedInNavigationView: true)])
        
        
        var routes: [Route<MoimScreen.State>]
        
        var isPresentedSheet: Bool = false
                
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
    }
    
    public var body: some ReducerOf<Self> {
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .mainTab(.moimListAction(.presentComposeSheet)))):
                state.isPresentedSheet = true
                state.routes.presentCover(.moimEdit(.init()))
                return .none
            case let .router(.routeAction(_, action: .mainTab(.moimListAction(.presentDetailSheet(moimSchedule))))):
                state.routes.presentCover(.moimEdit(.init(moimEditStore: .init(moimSchedule: moimSchedule))))
                state.isPresentedSheet = true
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



