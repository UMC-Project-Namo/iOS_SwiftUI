//
//  FriendAddItem.swift
//  FeatureFriendInvite
//
//  Created by 권석기 on 11/22/24.
//

import SwiftUI

import DomainFriend
import SharedDesignSystem

import Kingfisher

struct FriendAddItem: View {
    let friend: Friend
    let onDelete: () -> ()
    
    var body: some View {
        VStack {
            KFImage(URL(string: friend.profileImage ?? ""))
                .placeholder({
                    Image(asset: SharedDesignSystemAsset.Assets.friendDefaultImage)
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Text(friend.name)
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(Color.mainText)
        }
        .overlay(alignment: .topTrailing) {
            Circle()
                .frame(width: 20, height: 20)
                .overlay(Image(asset: SharedDesignSystemAsset.Assets.icXmark))
                .foregroundStyle(Color.white)
                .shadow(radius: 4)
                .offset(x: 10, y: -10)
                .onTapGesture {
                    onDelete()
                }
        }
    }
}
