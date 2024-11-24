//
//  ScheduleCoordinator.swift
//  FeatureGatheringSchedule
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import ComposableArchitecture
import TCACoordinators

import FeatureFriendInviteInterface
import FeatureLocationSearchInterface
import FeatureFriendInvite

@Reducer(state: .equatable)
public enum Screen {
    case scheduleEdit(GatheringScheduleStore)
    case locationSearch(LocationSearchStore)
    case friendInvite(FriendInviteStore)
}

@Reducer
public struct ScheduleCoordinator {
    public init() {}
        
    public struct State: Equatable {
        public init(schedule: GatheringScheduleStore.State = .init()) {
            self.schedule = schedule
            self.routes = [.root(.scheduleEdit(schedule), embedInNavigationView: true)]
        }
        
        var routes: [Route<Screen.State>]
        var schedule: GatheringScheduleStore.State
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
            case let .router(.routeAction(_, action: .friendInvite(.updatedFriendList(friendList)))):
                state.schedule.firndList = friendList
                state.routes = [.root(.scheduleEdit(state.schedule), embedInNavigationView: true)]
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.goToLocationSearch))):
                var location = LocationSearchStore.State()
                location.kakaoMap = state.schedule.kakaoMap
                state.routes.push(.locationSearch(location))
                return .none
            case .router(.routeAction(_, action: .locationSearch(.backButtonTapped))):
                state.routes = [.root(.scheduleEdit(state.schedule), embedInNavigationView: true)]
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.goToFriendInvite))):
                state.routes.push(.friendInvite(state.schedule.firndList))
                return .none
            case .router(.routeAction(_, action: .friendInvite(.backButtonTapped))):
                state.routes = [.root(.scheduleEdit(state.schedule), embedInNavigationView: true)]
                return .none          
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

