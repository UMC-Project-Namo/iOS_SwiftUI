//
//  MoimCoordinator.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/21/24.
//

import Foundation

import FeaturePlaceSearchInterface
import FeatureMoimInterface
import FeatureFriend

import ComposableArchitecture
import TCACoordinators

/**
 Root Coordinator for Moim(모임) Tab Feature
 
 Coordinator Structure:
 
 MoimCoordinator (루트 코디네이터)
 ├─ MainTab (메인 탭 화면)
 │  └─ MoimList (모임 목록)
 │
 ├─ MoimEditCoordinator (모임 수정 코디네이터)
 │  └─ Sheet Presentation
 │     ├─ Create Mode (새 모임 생성)
 │     └─ Edit Mode (기존 모임 수정)
 │
 └─ Notification (알림 화면)
     └─ Push Presentation
 
 Flow:
  1. 메인탭에서 모임 생성/수정 -> MoimEditCoordinator (Sheet)
  2. 메인탭에서 알림 버튼 -> Notification (Push)
 */
@Reducer(state: .equatable)
public enum MoimScreen {
    
    /// 메인탭(모임, 친구)
    case mainTab(MainViewStore)
    
    /// 모임 일정
    case moimEdit(MoimEditCoordinator)
    
    /// 친구 요청
    case notification
}

@Reducer
public struct MoimCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(
            routes: [.root(.mainTab(.initialState), embedInNavigationView: true)],
            mainTabStore: .initialState
        )
        
        /// 라우팅 리스트
        var routes: [Route<MoimScreen.State>]
        
        /// Sheet 보임여부
        var isPresentedSheet: Bool = false
                      
        /// 메인탭 스토어
        var mainTabStore: MainViewStore.State
                
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimScreen>)
        case mainTabAction(MainViewStore.Action)
    }
    
    public var body: some ReducerOf<Self> {        
        Scope(state: \.mainTabStore, action: \.mainTabAction) {
            MainViewStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {            
            // MARK: - 일정생성 Navigation
            case .router(.routeAction(_, action: .mainTab(.moimListAction(.presentComposeSheet)))):
                state.isPresentedSheet = true
                state.routes.presentCover(.moimEdit(.init()))
                return .none
            // MARK: - 일정조회 Navigation
            case let .router(.routeAction(_, action: .mainTab(.moimListAction(.presentDetailSheet(moimSchedule))))):
                state.routes.presentCover(.moimEdit(.init(moimEditStore: .init(moimSchedule: moimSchedule))))
                state.isPresentedSheet = true
                return .none
            // MARK: - 일정 생성, 편집 취소
            case .router(.routeAction(_, action: .moimEdit(.moimEditAction(.cancleButtonTapped)))):
                return .send(.mainTabAction(.moimListAction(.viewOnAppear)))
            case let .mainTabAction(.moimListAction(.moimListResponse(response))):
                state.mainTabStore.moimListStore.moimList = response
                state.isPresentedSheet = false
                state.routes = [.root(.mainTab(state.mainTabStore))]
                return .none
            // MARK: - 친구요청 Navigation
            case .router(.routeAction(_, action: .mainTab(.notificationButtonTap))):
                state.routes.push(.notification)
                return .none            
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}



