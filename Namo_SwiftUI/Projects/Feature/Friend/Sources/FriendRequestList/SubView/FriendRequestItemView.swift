//
//  FriendRequestItemView.swift
//  FeatureFriend
//
//  Created by 정현우 on 9/10/24.
//

import SwiftUI

import Kingfisher

import SharedDesignSystem
import DomainFriend

struct FriendRequestItemView: View {
	let friend: Friend
	
    var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 16) {
				KFImage(URL(string: friend.profileImage ?? ""))
					.frame(width: 48, height: 48)
					.clipShape(RoundedRectangle(cornerRadius: 15))
				
				VStack(alignment: .leading, spacing: 6) {
					Text("\(friend.nickname) #\(friend.tag)")
						.font(.pretendard(.bold, size: 15))
						.foregroundStyle(Color.mainText)
						.lineLimit(1)
					
					Text(friend.bio)
						.font(.pretendard(.regular, size: 12))
						.foregroundStyle(Color.mainText)
						.lineLimit(1)
					
				}
				
				Spacer(minLength: 0)
			}
			.padding(.leading, 16)
			.padding(.trailing, 20)
			.padding(.vertical, 12)
			.background(Color.itemBackground)
			
			HStack {
				Button(
					action: {
						
					}, label: {
						Text("수락")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(Color.mainOrange)
				
				Divider()
					.background(Color.textUnselected)
					.frame(width: 1, height: 32)
				
				Button(
					action: {
						
					}, label: {
						Text("거절")
							.frame(maxWidth: .infinity)
					}
				)
				.tint(Color.colorBlack)
			}
			.background(Color.white)
			.frame(height: 52)
			
		}
		.frame(height: 124)
		.frame(maxWidth: .infinity)
		.background()
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.shadow(color: .black.opacity(0.1), radius: 4)
    }
}
