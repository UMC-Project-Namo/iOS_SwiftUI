//
//  KakaoMapStore.swift
//  FeatureLocationSearch
//
//  Created by 권석기 on 11/21/24.
//

import ComposableArchitecture

extension KakaoMapStore {
    public init() {
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action { 
            default:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
