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
    case kakaoMap
}

@Reducer
public struct MoimEditCoordinator {
    public init() {}
    
    public struct State: Equatable {
        
        public init(moimEditStore: MoimEditStore.State) {
            self.routes = [.root(.createMoim(.init(moimSchedule: moimEditStore.moimSchedule)), embedInNavigationView: true)]
            self.moimEditStore = moimEditStore
        }
        
        public init() {
            self.routes = [.root(.createMoim(.init()), embedInNavigationView: true)]
            self.moimEditStore = .init()
        }
                
        var routes: [Route<MoimEditScreen.State>]
        
        var moimEditStore: MoimEditStore.State
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<MoimEditScreen>)
        case moimEditAction(MoimEditStore.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moimEditStore, action: \.moimEditAction) {
            MoimEditStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            case .router(.routeAction(_, action: .createMoim(.goToKakaoMapView))):
                state.routes.push(.kakaoMap)
                return .none
            case .router(.routeAction(_, action: .createMoim(.cancleButtonTapped))):
                return .send(.moimEditAction(.cancleButtonTapped))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
