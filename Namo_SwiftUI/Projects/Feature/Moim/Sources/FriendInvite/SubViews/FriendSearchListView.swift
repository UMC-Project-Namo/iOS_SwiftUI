//
//  FriendSearchListView.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/4/24.
//

import SwiftUI

import ComposableArchitecture

import DomainFriend

struct FriendSearchListView: View {
    let store: StoreOf<FriendInviteStore>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack {
                    ForEach(store.friendList, id: \.self.memberId) { friend in
                        let isAdded = store.addedFriend.map { $0.memberId }.contains(friend.memberId)
                        FriendAddItem(friend: friend, isAdded: isAdded)
                            .onTapGesture {
                                if isAdded {                                    
                                    store.send(.removeFriend(memberId: friend.memberId))
                                } else {
                                    store.send(.addFriend(friend))
                                }                                
                            }
                    }
                }
                .padding(.horizontal, 25)
            }            
        }
    }
}
