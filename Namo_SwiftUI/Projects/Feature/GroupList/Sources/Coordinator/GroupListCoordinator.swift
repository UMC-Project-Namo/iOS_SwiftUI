//
//  GroupListCoordinator.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import FeatureGatheringListInterface

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
public enum Screen {
    case group(GroupViewStore)
}

@Reducer
public struct GroupListCoordinator {
    public init() {}
        
    public struct State: Equatable {
        public init(routes: [Route<Screen.State>]) {
            self.routes = routes
        }
        public static let initialState = State(
            routes: [.root(.group(.init()), embedInNavigationView: true)]
        )
        
        var routes: [Route<Screen.State>]
        var group: GroupViewStore.State = .init()
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<Screen>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
