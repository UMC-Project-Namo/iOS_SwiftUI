//
//  GroupListCoordinator.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import FeatureGatheringListInterface
import FeatureGatheringScheduleInterface

import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
public enum Screen {
    case group(GroupViewStore)
    case schedule(ScheduleCoordinator)
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
        case group(GroupViewStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.group, action: \.group) {
            GroupViewStore()
        }
        
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .group(.gatherList(.scheduleCellSelected(meetingScheduleId))))):
                return .none
            case .router(.routeAction(_, action: .group(.presentComposeSheet))):
                state.routes.presentCover(.schedule(.initialState))
                return .none
//            case .router(.routeAction(_, action: .schedule(.scheduleEdit(.cancleButtonTapped)))):
//                state.routes.dismiss()
//                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
