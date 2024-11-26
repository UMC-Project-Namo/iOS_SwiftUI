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
import FeatureFriendInviteInterface

@Reducer(state: .equatable)
public enum Screen {
    case scheduleEdit(GatheringRootStore)
    case locationSearch(LocationSearchStore)
    case friendInvite(FriendInviteStore)
}

@Reducer
public struct ScheduleCoordinator {
    public init() {}
    
    public struct State: Equatable {
        public init(schedule: GatheringRootStore.State = .init()) {
            self.schedule = schedule
            self.routes = [.root(.scheduleEdit(schedule), embedInNavigationView: true)]
        }
        
        public var routes: [Route<Screen.State>]
        public var schedule: GatheringRootStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<Screen>)
        case dismissSheet
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .locationSearch(.updatedLocation(kakaoMap)))):
                state.schedule.kakaoMap = kakaoMap
                return .none
            case let .router(.routeAction(_, action: .friendInvite(.updatedFriendList(friendList)))):
                if case var .scheduleEdit(rootStore) = state.routes.first?.screen {
                    rootStore.friendList = friendList
                    state.routes = [.root(.scheduleEdit(rootStore), embedInNavigationView: true)]
                }
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.goToLocationSearch))):
                var location = LocationSearchStore.State()
                location.kakaoMap = state.schedule.kakaoMap
                state.routes.push(.locationSearch(location))
                return .none
            case .router(.routeAction(_, action: .locationSearch(.backButtonTapped))):
                if case var .scheduleEdit(rootStore) = state.routes.first?.screen {
                    rootStore.kakaoMap = state.schedule.kakaoMap
                    state.routes = [.root(.scheduleEdit(rootStore), embedInNavigationView: true)]
                }
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.goToFriendInvite))):
                state.routes.push(.friendInvite(state.schedule.friendList))
                return .none
            case .router(.routeAction(_, action: .friendInvite(.backButtonTapped))):
                state.routes.pop()
                return .none
            case .router(.routeAction(_, action: .scheduleEdit(.cancleButtonTapped))),
                    .router(.routeAction(_, action: .scheduleEdit(.createButtonConfirm))),
                    .router(.routeAction(_, action: .scheduleEdit(.deleteCompleted))):
                return .send(.dismissSheet)
            default:
               break
            }
            return .none            
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

