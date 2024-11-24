//
//  GatheringStore.swift
//  FeatureGathering
//
//  Created by 권석기 on 11/25/24.
//

import Foundation

import ComposableArchitecture

extension GatheringStore {
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
