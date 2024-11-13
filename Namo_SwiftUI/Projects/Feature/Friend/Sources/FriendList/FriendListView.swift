//
//  FriendListView.swift
//  FeatureFriend
//
//  Created by 정현우 on 9/2/24.
//

import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

public struct FriendListView: View {
	@Perception.Bindable var store: StoreOf<FriendListStore>
	
	public init(store: StoreOf<FriendListStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 20) {
				searchSection
					.padding(.top, 20)
					.padding(.horizontal, 30)
				
				if !store.friends.isEmpty {
					friendListSection
						.padding(.horizontal, 22)
				} else {
					EmptyListView(title: "추가된 친구가 없습니다.\n친구와 함께 나모를 사용해보세요!")
						.offset(y: -32.5)
				}
				
			}
			.onAppear {
				store.send(.loadFriends)
			}
			.overlay(alignment: .bottomTrailing) {
				addFriendButton
			}
			.namoPopupView(
				isPresented: $store.showAddFriendPopup,
				title: "새 친구",
				content: {
					addFriendPopup
				}
			)
//			.namoPopupView(
//				isPresented: $store.showFriendInfoPopup,
//				title: "친구 정보",
//				content: {
//					FriendInfoPopupView(
//						store: Store(
//							initialState: FriendInfoPopupStore.State(
//								friend: store.selectedFriend!
//							),
//							reducer: {
//								FriendInfoPopupStore()
//							}
//						)
//					)
//				}
//			)
			.namoPopupView(
				isPresented: $store.showFriendInfoPopup,
				title: "친구 정보",
				content: {
					IfLetStore(
						store.scope(
							state: \.friendInfoPopupState,
							action: \.friendInfoPopup
						)
					) { popupStore in
						FriendInfoPopupView(store: popupStore)
					}
				}
			)
			.namoToastView(
				isPresented: $store.showAddFriendRequestToast,
				title: store.addFriendRequestToastMessage
			)
		}
    }
	
	private var searchSection: some View {
		HStack(spacing: 32) {
			VStack(spacing: 4) {
				HStack(spacing: 8) {
					Image(asset: SharedDesignSystemAsset.Assets.icSearch)
                        .renderingMode(.template)
                        .foregroundColor(Color.textPlaceholder)                        
					
					TextField(
						"",
						text: $store.friendSearchTerm,
						prompt: Text("닉네임 혹은 이름 입력")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.textPlaceholder)
					)
					.font(.pretendard(.regular, size: 15))
				}
				
				Rectangle()
					.fill(Color.textPlaceholder)
					.frame(height: 1)
			}
			
			
			Button(
				action: {
					store.send(.searchFriends)
				},
				label: {
					Text("검색")
						.font(.pretendard(.bold, size: 15))
						.background {
							RoundedRectangle(cornerRadius: 4)
								.fill(Color.mainOrange)
								.frame(width: 58, height: 30)
						}
				}
			)
			.tint(Color.white)

		}
	}
	
	private var friendListSection: some View {
		ScrollView {
			LazyVStack(spacing: 20) {
				ForEach(store.friends, id: \.memberId) { friend in
					FriendItemView(
						friend: friend,
						favoriteToggleAction: {
							store.send(.favoriteBtnTapped(friendId: friend.memberId))
						}
					)
					.onTapGesture {
						store.send(.showFriendInfoPopup(friend))
					}
				}
			}
			.padding(.top, 3)
			.padding(.horizontal, 3)
			
			if store.showPageIndicator {
				ProgressView()
					.progressViewStyle(.circular)
					.onAppear {
						
					}
			}
			
			Spacer()
				.frame(height: 100)
		}
		.scrollIndicators(.hidden)
	}
	
	private var addFriendButton: some View {
		Button(
			action: {
				store.send(.showAddFriendPopup, animation: .default)
			},
			label: {
				Image(asset: SharedDesignSystemAsset.Assets.floatingAdd)
					.resizable()
					.frame(width: 56, height: 56)
			}
		)
		.padding(.trailing, 24)
		.padding(.bottom, 24)
	}
	
	private var addFriendPopup: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				Text("닉네임")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
				
				Spacer()
				
				VStack(spacing: 4) {
					TextField(
						"",
						text: $store.addFriendNickname,
						prompt: Text("입력")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.textPlaceholder)
					)
					.font(.pretendard(.regular, size: 15))
					
					Rectangle()
						.fill(Color.textPlaceholder)
						.frame(height: 1)
				}
				.frame(maxWidth: 180)
			}
			.padding(.bottom, 24)
			
			HStack(spacing: 0) {
				Text("태그 4자리")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
				
				Spacer()
				
				VStack(spacing: 4) {
					TextField(
						"",
						text: $store.addFriendTag,
						prompt: Text("입력")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.textPlaceholder)
					)
					.font(.pretendard(.regular, size: 15))
					
					Rectangle()
						.fill(Color.textPlaceholder)
						.frame(height: 1)
				}
				.frame(maxWidth: 180)
			}
			.padding(.bottom, 32)
			
			Button(
				action: {
					store.send(.addFriendRequestTapped)
				}, label: {
					HStack(spacing: 12) {
						Image(asset: SharedDesignSystemAsset.Assets.icAddFriend)
							.resizable()
							.frame(width: 20, height: 20)
						
						Text("친구 신청")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.colorBlack)
					}
					.padding(.horizontal, 20)
					.padding(.vertical, 10)
					.background(
						Capsule()
							.stroke(Color.colorBlack, lineWidth: 1)
					)
				}
			)
		}
		.padding(.top, 36)
		.padding(.bottom, 30)
		.padding(.horizontal, 32)
		.onAppear() {
			store.send(.resetAddFriendState)
		}
	}
	
}
