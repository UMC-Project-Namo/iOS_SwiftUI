//
//  FriendInviteStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/3/24.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct FriendInviteStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public struct State: Equatable {}
    
    public enum Action {
        case backButtonTapped
    }
}
