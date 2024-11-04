//
//  MoimEditCoordinator.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import Foundation

import DomainMoimInterface
import DomainFriend
import FeatureMoimInterface
import FeaturePlaceSearchInterface
import FeatureFriendInterface
import SharedDesignSystem

import ComposableArchitecture
import TCACoordinators

/**
 MoimEdit(모임 편집) 코디네이터
 
 Coordinator Structure:
 
 MoimEditCoordinator (모임 편집 코디네이터)
 ├─ CreateMoim (모임 생성/수정 화면)
 │  ├─ KakaoMap (장소 검색)
 │  │  └─ Push Presentation
 │  │     ├─ 지도 검색
 │  │     └─ POI 선택
 │  │
 │  └─ FriendInvite (친구 초대)
 │      └─ Push Presentation
 │
 State Management:
 - moimEditStore: 모임 생성/수정 관련 상태
 - placeSearchStore: 카카오맵 장소 검색 관련 상태
 
 Navigation Flow:
 1. CreateMoim -> KakaoMap (Push)
 - 장소 선택 후 데이터 전달 (위치명, 좌표, ID)
 2. CreateMoim -> FriendInvite (Push)
 - 친구 선택 후 초대 목록 관리
 3. 취소/완료 -> Dismiss to Parent Coordinator
 */
@Reducer(state: .equatable)
public enum MoimEditScreen {
    case createMoim(MoimEditStore)
    case kakaoMap(PlaceSearchStore)
    case friendInvite(FriendInviteStore)
}

@Reducer
public struct MoimEditCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init(moimEditStore: MoimEditStore.State) {
            self.moimEditStore = moimEditStore
            self.placeSearchStore = .init()
            self.friendInviteStore = .init()
            self.routes = [.root(.createMoim(moimEditStore), embedInNavigationView: true)]
        }
        
        public init() {
            self.moimEditStore = .init()
            self.placeSearchStore = .init()
            self.friendInviteStore = .init()
            self.routes = [.root(.createMoim(.init()), embedInNavigationView: true)]
        }
        
        var routes: [Route<MoimEditScreen.State>]
        
        var moimEditStore: MoimEditStore.State
        var placeSearchStore: PlaceSearchStore.State
        var friendInviteStore: FriendInviteStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimEditScreen>)
        case moimEditAction(MoimEditStore.Action)
        case placeSearchAction(PlaceSearchStore.Action)
        case friendInviteAction(FriendInviteStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimEditStore, action: \.moimEditAction) {
            MoimEditStore()
        }
        Scope(state: \.placeSearchStore, action: \.placeSearchAction) {
            PlaceSearchStore()
        }
        Scope(state: \.friendInviteStore, action: \.friendInviteAction) {
            FriendInviteStore()
        }
        
        //TODO: - 코디네이터는 화면이동 및 데이터 조율만을 담당하도록(현재는 비즈니스로직이 흔재)
        Reduce<State, Action> { state, action in
            switch action {
                //MARK: - 장소검색 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToKakaoMapView))):
                state.routes.push(.kakaoMap(state.placeSearchStore))
                return .none
                // MARK: - 모임생성 수정 완료/취소
            case .router(.routeAction(_, action: .createMoim(.cancleButtonTapped))),
                    .router(.routeAction(_, action: .createMoim(.createButtonConfirm))):
                return .send(.moimEditAction(.cancleButtonTapped))
                // MARK: - 장소선택 완료/취소
            case .router(.routeAction(_, action: .kakaoMap(.backButtonTapped))):
                if case var .createMoim(editStore) = state.routes[0].screen {
                    editStore.moimSchedule.locationName = state.placeSearchStore.locationName
                    editStore.moimSchedule.latitude = state.placeSearchStore.y
                    editStore.moimSchedule.longitude = state.placeSearchStore.x
                    editStore.moimSchedule.kakaoLocationId = state.placeSearchStore.id
                    state.routes = [.root(.createMoim(editStore), embedInNavigationView: true)]
                }
                return .none
                // MARK: - 검색결과 업데이트
            case let .router(.routeAction(_, action: .kakaoMap(.responsePlaceList(placeList)))):
                state.placeSearchStore.placeList = placeList
                return .none
                // MARK: - 장소선택
            case let .router(.routeAction(_, action: .kakaoMap(.poiTapped(poiID)))):
                guard let place = state.placeSearchStore.placeList.filter({ $0.id == poiID }).first else { return .none }
                return .send(.placeSearchAction(.locationUpdated(place)))
                // MARK: - 친구초대 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToFriendInvite))):
                state.routes.push(.friendInvite(state.friendInviteStore))
                return .none
                // MARK: - 친구 초대 뒤로가기
            case .router(.routeAction(_, action: .friendInvite(.backButtonTapped))):
                if case var .createMoim(editStore) = state.routes[0].screen {
                    editStore.moimSchedule.participants = state.friendInviteStore.addedFriend.map { $0.toParticipant() }
                    state.routes = [.root(.createMoim(editStore), embedInNavigationView: true)]
                }
                return .none
                // MARK: - 친구 초대
            case let .router(.routeAction(_, action: .friendInvite(.addFriend(friend)))):
                state.friendInviteStore.addedFriend.append(friend)
                return .none
                // MARK: - 초대친구 제거
            case let .router(.routeAction(_, action: .friendInvite(.removeFriend(memberId)))):
                guard let index = state.friendInviteStore.addedFriend.firstIndex(where: {$0.memberId == memberId}) else { return .none }
                state.friendInviteStore.addedFriend.remove(at: index)
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}


