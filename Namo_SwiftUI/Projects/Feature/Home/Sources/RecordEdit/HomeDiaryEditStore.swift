//
//  HomeDiaryEditStore.swift
//  FeatureHome
//
//  Created by 박민서 on 10/31/24.
//

import ComposableArchitecture

@Reducer
public struct HomeDiaryEditStore {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}


