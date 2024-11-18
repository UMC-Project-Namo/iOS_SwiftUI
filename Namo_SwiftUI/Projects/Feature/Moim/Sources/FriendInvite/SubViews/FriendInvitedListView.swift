//
//  FriendInvitedListView.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/4/24.
//

import SwiftUI

import ComposableArchitecture

import DomainFriend
import FeatureMoimInterface

struct FriendInvitedListView: View {
    let store: StoreOf<FriendInviteStore>
    
    var body: some View {
        WithPerceptionTracking {
            LazyVStack {
                if store.addedFriend.isEmpty {
                    Text("아직 초대한 친구가 없습니다.")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                
                ForEach(store.addedFriend, id: \.self.memberId) { friend in
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
