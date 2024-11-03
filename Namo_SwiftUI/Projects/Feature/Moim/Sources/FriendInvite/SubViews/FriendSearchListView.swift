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
                        FriendAddItem(friend: friend, isAdded: store.addedFriend.contains(friend))
                            .onTapGesture {
                                store.send(.addFriend(friend))
                            }
                    }
                }
                .padding(.horizontal, 25)
            }
        }
    }
}
