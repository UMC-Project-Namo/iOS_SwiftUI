//
//  FriendInviteStore.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/3/24.
//

import Foundation

import ComposableArchitecture

import FeatureMoimInterface
import DomainFriendInterface

extension FriendInviteStore {
    public init() {
        @Dependency(\.friendUseCase) var friendUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case .searchButtonTapped:
                return .run { [state] send in
                    let response = try await friendUseCase.getFriends(page: 1, searchTerm: state.searchText)
                    await send(.searchResponse(response))
                }
            case let .searchResponse(response):
                state.friendList = response.friendList
                return .none
            case let .addFriend(friend):
                state.addedFriend.append(friend)
                return .none
            case let .removeFriend(memberId):
                guard let index = state.addedFriend.firstIndex(where: { $0.memberId == memberId }) else { return .none }
                state.addedFriend.remove(at: index)
                return .none
            default:
                return .none
            }}
        self.init(reducer: reducer)
    }
}
