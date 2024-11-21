//
//  FriendInviteStoreInterface.swift
//  FeatureFriendInvite
//
//  Created by 권석기 on 11/21/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct FriendInviteStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action {}
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
