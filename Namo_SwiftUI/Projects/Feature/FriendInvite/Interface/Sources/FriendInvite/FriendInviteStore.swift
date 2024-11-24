//
//  FriendInviteStore.swift
//  FeatureFriendInvite
//
//  Created by 권석기 on 11/21/24.
//

import Foundation

import Domain
import DomainFriendInterface

import ComposableArchitecture

public extension FriendInviteStore {
    init() {
        @Dependency(\.friendUseCase) var friendUseCase
                
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case .searchButtonTapped:
                return .run { [state] send in
                    let response = try await friendUseCase.getFriends(page: 1, searchTerm: state.searchText)
                    await send(.searchResponse(response))
                }
            case let .searchResponse(response):
                state.searchFriendList = IdentifiedArray(uniqueElements: response.friendList)
                return .send(.loadFriendList)
            case .loadFriendList:
                let addedFriend = state.searchFriendList.filter { state.friendList.contains($0.memberId) }
                state.addedFriendList.append(contentsOf: addedFriend)
                return .none
            case .toggleAddedFriendList:
                state.showingFriendInvites.toggle()
                return .none
            case let .addFriend(friend):
                guard !(state.addedFriendList.contains(where: { $0.memberId == friend.memberId })) else {
                    return .none
                }
                state.willAddFriendList.append(friend)
                return .none            
            case .confirmAddFriend:
                state.addedFriendList.append(contentsOf: state.willAddFriendList)
                state.willAddFriendList.removeAll()
                return .send(.updatedFriendList(state))
            default:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}

