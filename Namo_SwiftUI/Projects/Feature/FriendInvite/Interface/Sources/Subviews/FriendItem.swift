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

struct FriendItem: View {
    let friend: Friend
    let isAdded: Bool
    let action: () -> ()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                KFImage(URL(string: friend.profileImage ?? ""))
                    .placeholder({
                        Image(asset: SharedDesignSystemAsset.Assets.friendDefaultImage)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Text(friend.nickname)
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                        Image(asset: friend.favoriteFriend ? SharedDesignSystemAsset.Assets.icHeartSelected : SharedDesignSystemAsset.Assets.icHeart)
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(friend.bio)
                            .font(.pretendard(.regular, size: 12))
                            .foregroundStyle(Color.mainText)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                }
                
                Button(action: {action()}, label: {
                    Image(asset: isAdded ? SharedDesignSystemAsset.Assets.icAddedSelected :
                            SharedDesignSystemAsset.Assets.icAdded)
                })
            }
            .padding(.leading, 16)
            .padding(.trailing, 24)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity, maxHeight: 72)
        .background(Color.itemBackground)
        .cornerRadius(10)
    }
}
