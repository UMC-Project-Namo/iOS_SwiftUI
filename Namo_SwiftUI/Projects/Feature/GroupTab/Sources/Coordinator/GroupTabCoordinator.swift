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
public struct GroupTabCoordinator {
    public init() {}
    
    public struct State: Equatable {
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
                let existFriendList = scheduleDetail.participants.map { $0.userId }
                let friendInvite: FriendInviteStore.State = .init(friendList: existFriendList)
                var schedule: GatheringStore.State = .init()
                var kakaoMap: KakaoMapStore.State = .init()
                
                schedule.title = scheduleDetail.title
                schedule.startDate = scheduleDetail.startDate
                schedule.endDate = scheduleDetail.endDate
                schedule.imageUrl = scheduleDetail.imageUrl
                schedule.scheduleId = scheduleDetail.scheduleId
                
                kakaoMap.kakaoLocationId = scheduleDetail.kakaoLocationId
                kakaoMap.longitude = scheduleDetail.longitude
                kakaoMap.latitude = scheduleDetail.latitude
                kakaoMap.locationName = scheduleDetail.locationName
                
                let rootStore = GatheringRootStore.State(
                    editMode: scheduleDetail.isOwner ? .edit : .view,
                    schedule: schedule,
                    kakaoMap: kakaoMap,
                    friendInvite: friendInvite
                )
                
                state.routes.presentCover(.schedule(.init(schedule: rootStore)))
                return .none
            case .router(.routeAction(_, action: .group(.presentComposeSheet))):
                state.routes.presentCover(.schedule(.init()))
                return .none
            case .router(.routeAction(_, action: .schedule(.dismissSheet))):
                return .send(.group(.scheduleList(.loadSceduleList)))
            case .group(.scheduleList(.responseSceduleList)):
                state.routes = [.root(.group(state.group), embedInNavigationView: true)]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
