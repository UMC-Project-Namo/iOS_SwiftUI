//
//  MoimEditCoordinator.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import Foundation

import ComposableArchitecture
import TCACoordinators

import DomainMoimInterface
import FeatureMoimInterface
import FeaturePlaceSearchInterface
import SharedDesignSystem


@Reducer(state: .equatable)
public enum MoimEditScreen {
    case createMoim(MoimEditStore)
    case kakaoMap(PlaceSearchStore)
}

@Reducer
public struct MoimEditCoordinator {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init(moimEditStore: MoimEditStore.State) {
            self.moimEditStore = moimEditStore
            self.placeSearchStore = .init()
            self.routes = [.root(.createMoim(moimEditStore), embedInNavigationView: true)]
        }
        
        public init() {
            self.moimEditStore = .init()
            self.placeSearchStore = .init()
            self.routes = [.root(.createMoim(.init()), embedInNavigationView: true)]
        }
        
        var routes: [Route<MoimEditScreen.State>]
        
        var moimEditStore: MoimEditStore.State
        var placeSearchStore: PlaceSearchStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimEditScreen>)
        case moimEditAction(MoimEditStore.Action)
        case placeSearchAction(PlaceSearchStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimEditStore, action: \.moimEditAction) {
            MoimEditStore()
        }
        Scope(state: \.placeSearchStore, action: \.placeSearchAction) {
            PlaceSearchStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
                /// 지도검색 이동
            case .router(.routeAction(_, action: .createMoim(.goToKakaoMapView))):
                state.routes.push(.kakaoMap(state.placeSearchStore))
                return .none
                /// 작업 취소 또는 완료시
            case .router(.routeAction(_, action: .createMoim(.cancleButtonTapped))),
                    .router(.routeAction(_, action: .createMoim(.createButtonConfirm))):
                return .send(.moimEditAction(.cancleButtonTapped))
                /// 지도검색 뒤로가기
            case .router(.routeAction(_, action: .kakaoMap(.backButtonTapped))):
                if case var .createMoim(editStore) = state.routes[0].screen {
                    editStore.moimSchedule.locationName = state.placeSearchStore.locationName
                    editStore.moimSchedule.latitude = state.placeSearchStore.y
                    editStore.moimSchedule.longitude = state.placeSearchStore.x
                    editStore.moimSchedule.kakaoLocationId = state.placeSearchStore.id
                    state.routes = [.root(.createMoim(editStore), embedInNavigationView: true)]
                }
                return .none
                /// 검색결과
            case let .router(.routeAction(_, action: .kakaoMap(.responsePlaceList(placeList)))):
                state.placeSearchStore.placeList = placeList
                return .none
                /// 지도핀 선택
            case let .router(.routeAction(_, action: .kakaoMap(.poiTapped(poiID)))):
                guard let place = state.placeSearchStore.placeList.filter({ $0.id == poiID }).first else { return .none }
                return .send(.placeSearchAction(.locationUpdated(place)))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
        
    }
}
