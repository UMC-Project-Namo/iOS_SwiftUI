//
//  DiaryEditStore.swift
//  FeatureActivityInterface
//
//  Created by 권석기 on 11/18/24.
//

import Foundation

import ComposableArchitecture

public extension DiaryEditStore {
    init() {
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
    
    
