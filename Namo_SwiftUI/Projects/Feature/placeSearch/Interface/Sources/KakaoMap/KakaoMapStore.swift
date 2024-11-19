//
//  KakaoMapStore.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 11/19/24.
//

import ComposableArchitecture

extension KakaoMapStore {
    public init() {
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case let .createPoi(longitude, latitude):
                state.longitude = longitude
                state.latitude = latitude
                return .none
            default:
                return .none
            }
        }        
        self.init(reducer: reducer)
    }
}
