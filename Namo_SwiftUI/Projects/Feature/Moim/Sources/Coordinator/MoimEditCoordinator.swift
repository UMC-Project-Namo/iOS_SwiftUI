//
//  MoimEditCoordinator.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

import SharedDesignSystem
import FeatureMoimInterface
import FeaturePlaceSearchInterface
import DomainMoimInterface

@Reducer(state: .equatable)
public enum MoimEditScreen {
    case createMoim(MoimEditStore)
    case kakaoMap(PlaceSearchStore)
}

@Reducer
public struct MoimEditCoordinator {
    public init() {}
    
    public struct State: Equatable {
        
        public init(moimEditStore: MoimEditStore.State) {
            self.moimEditStore = moimEditStore
            self.placeSearchStore = .init()
            self.routes = [.root(.createMoim(moimEditStore), embedInNavigationView: true)]
        }
        
        public init() {
            self.routes = [.root(.createMoim(.init()), embedInNavigationView: true)]
            self.moimEditStore = .init()
            self.placeSearchStore = .init()
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
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .createMoim(.goToKakaoMapView))):
                state.routes.push(.kakaoMap(.init()))
                return .none
            case .router(.routeAction(_, action: .createMoim(.cancleButtonTapped))):
                return .send(.moimEditAction(.cancleButtonTapped))
            case let .router(.routeAction(_, action: .kakaoMap(actions))):
                switch actions {
                case let .responsePlaceList(placeList):
                    state.placeSearchStore.placeList = placeList
                    return .none
                case .backButtonTapped:
                    state.routes = [.root(.createMoim(state.moimEditStore))]
                    return .none
                case let .poiTapped(poiID):
                    guard let place = state.placeSearchStore.placeList.filter({ $0.id == poiID }).first else { return .none }
                    return .send(.moimEditAction(.locationUpdated(place)))
                default:
                    return .none
                }
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
