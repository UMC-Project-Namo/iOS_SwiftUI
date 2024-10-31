//
//  FriendItemView.swift
//  FeatureFriend
//
//  Created by 정현우 on 9/2/24.
//

import SwiftUI

import Kingfisher

import SharedDesignSystem
import DomainFriend

struct FriendItemView: View {
	let friend: Friend
	let favoriteToggleAction: () -> Void
	
	var body: some View {
		HStack(spacing: 0) {
			KFImage(URL(string: friend.profileImage ?? ""))
				.frame(width: 48, height: 48)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				.padding(.trailing, 16)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(friend.nickname)
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
					.lineLimit(1)
				
				Text(friend.bio)
					.font(.pretendard(.regular, size: 12))
					.foregroundStyle(Color.mainText)
					.lineLimit(1)
			}
			
			Spacer(minLength: 16)
			
			Button(
				action: {
					favoriteToggleAction()
				},
				label: {
					Image(asset: friend.favoriteFriend ? SharedDesignSystemAsset.Assets.icFavoriteFill : SharedDesignSystemAsset.Assets.icFavorite)
						.resizable()
						.frame(width: 28, height: 28)
				}
			)
			
		}
		.padding(.leading, 16)
		.padding(.trailing, 24)
		.background {
			RoundedRectangle(cornerRadius: 10)
				.fill(Color.itemBackground)
				.frame(height: 72)
				.shadow(
					color: Color.black.opacity(0.1),
					radius: 2
				)
		}
		.frame(height: 72)
	}
}
