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
import FeatureFriend
import FeatureActivityInterface
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
    case friendCalendar
    case diary(DiaryEditStore)
}

@Reducer
public struct MoimEditCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init(moimEditStore: MoimEditStore.State = .init()) {
            self.moimEdit = moimEditStore
            self.placeSearch = .init()
            self.friendInvite = .init()           
            self.diaryEdit = .init()
            self.routes = [.root(.createMoim(moimEditStore), embedInNavigationView: true)]
        }
        
        var routes: [Route<MoimEditScreen.State>]
        
        var diaryEdit: DiaryEditStore.State
        var moimEdit: MoimEditStore.State
        var placeSearch: PlaceSearchStore.State
        var friendInvite: FriendInviteStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimEditScreen>)
        case moimEdit(MoimEditStore.Action)
        case placeSearch(PlaceSearchStore.Action)
        case friendInvite(FriendInviteStore.Action)
        case diaryEdit(DiaryEditStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimEdit, action: \.moimEdit) {
            MoimEditStore()
        }
        Scope(state: \.placeSearch, action: \.placeSearch) {
            PlaceSearchStore()
                ._printChanges()
        }
        Scope(state: \.friendInvite, action: \.friendInvite) {
            FriendInviteStore()
        }
        Scope(state: \.diaryEdit, action: \.diaryEdit) {
            DiaryEditStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
                //MARK: - 장소검색 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToKakaoMapView))):
                state.routes.push(.kakaoMap(state.placeSearch))
                return .none
                // MARK: - 모임생성 수정 완료/취소/삭제
            case .router(.routeAction(_, action: .createMoim(.cancleButtonTapped))),
                    .router(.routeAction(_, action: .createMoim(.createButtonConfirm))),
                    .router(.routeAction(_, action: .createMoim(.deleteConfirm))):
                return .send(.moimEdit(.cancleButtonTapped))
                // MARK: - 장소선택 완료/취소
            case .router(.routeAction(_, action: .kakaoMap(.backButtonTapped))):                
                if case var .createMoim(editStore) = state.routes[0].screen {
                    state.routes = [.root(.createMoim(editStore), embedInNavigationView: true)]
                }                
                return .none
                // MARK: - 친구 초대
            case let .router(.routeAction(_, action: .friendInvite(.addFriend(friend)))):
                return .send(.friendInvite(.addFriend(friend)))
                // MARK: - 초대친구 제거
            case let .router(.routeAction(_, action: .friendInvite(.removeFriend(memberId)))):
                return .send(.friendInvite(.removeFriend(memberId: memberId)))
                // MARK: - 친구초대 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToFriendInvite))):
                state.routes.push(.friendInvite(state.friendInvite))
                return .none
                // MARK: - 친구캘린더 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToFriendCalendar))):
                state.routes.push(.friendCalendar)
                return .none
                // MARK: - 친구 초대 뒤로가기
            case .router(.routeAction(_, action: .friendInvite(.backButtonTapped))):
                if case var .createMoim(editStore) = state.routes[0].screen {
                    state.routes = [.root(.createMoim(editStore), embedInNavigationView: true)]
                }
                return .none
               // MARK: - 모임기록 Navigation
            case .router(.routeAction(_, action: .createMoim(.goToDiary))):
                state.routes.push(.diary(.init()))
                return .none
              // MARK: - 모임기록 뒤로가기
            case .router(.routeAction(_, action: .diary(.backButtonTapped))):
                state.routes.pop()
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}


