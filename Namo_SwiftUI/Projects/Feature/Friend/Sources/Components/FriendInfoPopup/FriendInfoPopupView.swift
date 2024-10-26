//
//  FriendInfoPopupView.swift
//  FeatureFriend
//
//  Created by 정현우 on 9/3/24.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

import SharedDesignSystem
import DomainFriend

public struct FriendInfoPopupView: View {
	let store: StoreOf<FriendInfoPopupStore>
	
	public init(store: StoreOf<FriendInfoPopupStore>) {
		self.store = store
	}

	public var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			imageAndNickname
				.padding(.bottom, 20)
			
			descriptionAndBirth
				.padding(.bottom, 32)
			
			if store.isRequestPopup {
				acceptAndRejectBtn
			} else {
				scheduleAndDeleteBtn
			}
		}
		.padding(.horizontal, 30)
		.padding(.top, 20)
		.padding(.bottom, 26)
	}
	
	private var imageAndNickname: some View {
		HStack(spacing: 0) {
			KFImage(URL(string: store.friend.profileImage ?? ""))
				.frame(width: 72, height: 72)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				.padding(.trailing, 20)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(store.friend.nickname)
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
					.lineLimit(1)
				
				Text("#\(store.friend.tag)")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
					.lineLimit(1)
			}
			
			Spacer(minLength: 20)
			
			
			if !store.isRequestPopup {
				Button(
					action: {
						store.send(.favoriteBtnTappedInInfo)
					}, label: {
						Image(asset: store.friend.favoriteFriend ? SharedDesignSystemAsset.Assets.icFavoriteFill : SharedDesignSystemAsset.Assets.icFavorite)
							.resizable()
							.frame(width: 28, height: 28)
					}
				)
			}
		}
	}
	
	private var descriptionAndBirth: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(store.friend.bio)
				.font(.pretendard(.regular, size: 15))
				.foregroundStyle(Color.mainText)
				.padding(.bottom, 16)
			
			HStack {
				Text("이름")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
				
				Spacer()
				
				Text(store.friend.name)
					.font(.pretendard(.regular, size: 15))
					.foregroundStyle(Color.mainText)
			}
			.padding(.bottom, 16)
			
			HStack {
				Text("생일")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
				
				Spacer()
				
				Text(store.friend.birthday)
					.font(.pretendard(.regular, size: 15))
					.foregroundStyle(Color.mainText)
			}
		}
	}
	
	private var scheduleAndDeleteBtn: some View {
		HStack {
			Spacer(minLength: 0)
			
			Button(
				action: {
					store.send(.gotoFriendCalendar)
				}, label: {
					HStack(spacing: 12) {
						Image(asset: SharedDesignSystemAsset.Assets.icCalendar)
							.resizable()
							.frame(width: 20, height: 20)
						
						Text("일정")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.colorBlack)
					}
					.frame(width: 120, height: 40)
					.background(
						Capsule()
							.stroke(Color.colorBlack, lineWidth: 1)
					)
				}
			)
			.padding(.horizontal, 16)
			
			Button(
				action: {
					store.send(.friendDelete)
				}, label: {
					HStack(spacing: 12) {
						Image(asset: SharedDesignSystemAsset.Assets.icTrashcan)
							.resizable()
							.frame(width: 20, height: 20)
						
						Text("삭제")
							.font(.pretendard(.regular, size: 15))
							.foregroundColor(Color.colorBlack)
					}
					.frame(width: 120, height: 40)
					.background(
						Capsule()
							.stroke(Color.colorBlack, lineWidth: 1)
					)
				}
			)
			
			Spacer(minLength: 0)
			
		}
	}
	
	private var acceptAndRejectBtn: some View {
		HStack {
			Spacer(minLength: 0)
			
			Button(
				action: {
				
				}, label: {
					Text("수락")
						.font(.pretendard(.regular, size: 15))
						.foregroundColor(Color.colorBlack)
						.frame(width: 120, height: 40)
						.background(
							Capsule()
								.stroke(Color.colorBlack, lineWidth: 1)
						)
				}
			)
			.padding(.horizontal, 16)
			
			Button(
				action: {
					
				}, label: {
					Text("거절")
						.font(.pretendard(.regular, size: 15))
						.foregroundColor(Color.colorBlack)
						.frame(width: 120, height: 40)
						.background(
							Capsule()
								.stroke(Color.colorBlack, lineWidth: 1)
						)
				}
			)
			
			Spacer(minLength: 0)
			
		}
	}
}
