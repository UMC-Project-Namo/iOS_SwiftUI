//
//  GroupListCoordinator.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import DomainFriend
import FeatureGatheringInterface
import FeatureLocationSearchInterface
import FeatureFriendInviteInterface

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
            case let .router(.routeAction(_, action: .group(.scheduleList(.presentDetailSheet(scheduleDetail))))):
                var schedule: GatheringStore.State = .init()
                var kakaoMap: KakaoMapStore.State = .init()
                var friendInvite: FriendInviteStore.State = .init(friendList: scheduleDetail.participants.map { $0.userId })
                            
                schedule.title = scheduleDetail.title
                schedule.startDate = scheduleDetail.startDate
                schedule.endDate = scheduleDetail.endDate
                schedule.imageUrl = scheduleDetail.imageUrl
                schedule.scheduleId = scheduleDetail.scheduleId
                
                kakaoMap.kakaoLocationId = scheduleDetail.kakaoLocationId
                kakaoMap.longitude = scheduleDetail.longitude
                kakaoMap.latitude = scheduleDetail.latitude
                kakaoMap.locationName = scheduleDetail.locationName
                
                var rootStore = GatheringRootStore.State(
                    schedule: schedule,
                    kakaoMap: kakaoMap,
                    friendInvite: friendInvite
                )
                
                rootStore.editMode = scheduleDetail.isOwner ? .edit : .view
                                                
                state.routes.presentCover(.schedule(.init(schedule: rootStore)))
                return .none
            case .router(.routeAction(_, action: .group(.presentComposeSheet))):
                state.routes.presentCover(.schedule(.init()))
                return .none
            case .router(.routeAction(_, action: .schedule(.dismissSheet))):
                state.routes.dismiss()
                return .send(.group(.reloadScheduleList))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
