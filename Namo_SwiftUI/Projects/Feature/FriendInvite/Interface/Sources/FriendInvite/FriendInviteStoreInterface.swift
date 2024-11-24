//
//  FriendInviteStoreInterface.swift
//  FeatureFriendInvite
//
//  Created by 권석기 on 11/21/24.
//

import Foundation

import DomainFriend
import DomainFriendInterface

import ComposableArchitecture

@Reducer
public struct FriendInviteStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(friendList: [Int] = []) {
            self.friendList = friendList
        }
        
        internal let friendList: [Int]
        
        public var searchText = ""
        public var showingFriendInvites = false
        public var searchFriendList: IdentifiedArrayOf<Friend> = []
        public var addedFriendList: IdentifiedArrayOf<Friend> = []
        public var willAddFriendList: IdentifiedArrayOf<Friend> = []
        public var maxAvailableInvites: Int {
            10 - addedFriendList.count
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case searchButtonTapped
        case searchResponse(FriendResponse)
        case backButtonTapped
        case toggleAddedFriendList
        case addFriend(Friend)
        case confirmAddFriend
        case addFriendConfirmButtonTapped
        case updatedFriendList(FriendInviteStore.State)   
        case loadFriendList
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
