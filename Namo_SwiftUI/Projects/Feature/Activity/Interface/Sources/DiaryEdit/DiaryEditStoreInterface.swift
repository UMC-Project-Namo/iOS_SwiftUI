//
//  DiaryEditStoreInterface.swift
//  FeatureActivityInterface
//
//  Created by 권석기 on 11/18/24.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct DiaryEditStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case backButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        reducer
    }
}
