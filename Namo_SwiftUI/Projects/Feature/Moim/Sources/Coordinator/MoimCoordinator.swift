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
    // 모임 일정
    case moimSchedule(MainViewStore)
    
    // 친구 캘린더 화면
    case friendCalendar(FriendCalendarStore)
    
    // 친구 요청
    case friendRequest(FriendRequestListStore)
}

@Reducer
public struct MoimCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.moimSchedule(.initialState), embedInNavigationView: true)],
                                               moimSchedule: .initialState,
                                               friendRequest: .init(friends: [])
        )
        
        var routes: [Route<MoimScreen.State>]
        var moimSchedule: MainViewStore.State
        var friendRequest: FriendRequestListStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case moimSchedule(MainViewStore.Action)
        case friendRequest(FriendRequestListStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimSchedule, action: \.moimSchedule) {
            MainViewStore()
        }
        Scope(state: \.friendRequest, action: \.friendRequest) {
            FriendRequestListStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
                // 모임일정 -> 친구요청
            case .router(.routeAction(_, action: .moimSchedule(.notificationButtonTap))):
                state.routes.push(.friendRequest(state.friendRequest))
                return .none
                // 모임일정 -> 친구캘린더
            case .router(.routeAction(_, action: .moimSchedule(.navigateToFriendCalendar(let friend)))):
                state.routes.push(.friendCalendar(.init(friend: friend)))
                return .none        
                // 친구캘린더에서 뒤로가기
            case .router(.routeAction(_, action: .friendCalendar(.backBtnTapped))):
                state.routes.pop()
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



