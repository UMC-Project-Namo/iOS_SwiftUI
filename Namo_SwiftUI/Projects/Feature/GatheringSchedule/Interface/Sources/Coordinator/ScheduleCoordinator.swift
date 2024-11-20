//
//  ScheduleCoordinator.swift
//  FeatureGatheringSchedule
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import ComposableArchitecture
import TCACoordinators
import FeatureLocationSearchInterface
import FeatureLocationSearch


@Reducer(state: .equatable)
public enum Screen {
    case scheduleEdit(GatheringScheduleStore)
    case locationSearch(LocationSearchStore)
}

@Reducer
public struct ScheduleCoordinator {
    public init() {}
        
    public struct State: Equatable {
        public init(routes: [Route<Screen.State>]) {
            self.routes = routes
        }
        public static let initialState = State(
            routes: [.root(.scheduleEdit(.init()), embedInNavigationView: true)]
        )
        
        var routes: [Route<Screen.State>]
        var schedule: GatheringScheduleStore.State = .init()
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<Screen>)
        case schedule(GatheringScheduleStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.schedule, action: \.schedule) {
            GatheringScheduleStore()
        }
        
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .locationSearch(.updatedLocation(kakaoMap)))):
                state.schedule.kakaoMap = kakaoMap
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.goToLocationSearch))):
                state.routes.push(.locationSearch(.init()))
                return .none
            case .router(.routeAction(_, action: .locationSearch(.backButtonTapped))):
                state.routes = [.root(.scheduleEdit(state.schedule), embedInNavigationView: true)]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

