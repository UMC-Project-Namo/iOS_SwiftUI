//
//  FriendRequestListView.swift
//  FeatureFriend
//
//  Created by 정현우 on 9/10/24.
//

import SwiftUI

import ComposableArchitecture

import SharedDesignSystem
import DomainFriend

public struct FriendRequestListView: View {
	@Perception.Bindable var store: StoreOf<FriendRequestListStore>
	
	public init(store: StoreOf<FriendRequestListStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			ScrollView(.vertical, showsIndicators: false) {
				LazyVStack(spacing: 20) {
					ForEach(store.friends, id: \.memberId) { friend in
						FriendRequestItemView(friend: friend)
							.onTapGesture {
								store.send(.friendDetailTapped(friend))
							}
					}
				}
				.padding(.top, 20)
				.padding(.horizontal, 25)
				
				Spacer()
					.frame(height: 100)
			}
			.namoPopupView(
				isPresented: $store.showFriendInfoPopup,
				title: "친구 정보",
				content: {
					FriendInfoPopupView(
						store: Store(
							initialState: FriendInfoPopupStore.State(
								friend: store.selectedFriend!,
								isRequestPopup: true
							),
							reducer: {
								FriendInfoPopupStore()
							}
						)
					)
				}
			)
		}
	}
}
