//
//  FriendAddItem.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/11/24.
//

import SwiftUI

import DomainFriend
import SharedDesignSystem

struct FriendAddItem: View {
    let friend: Friend
    let isAdded: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(asset: SharedDesignSystemAsset.Assets.appLogo)
                    .cornerRadius(10)
                
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Text(friend.nickname)
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                        Image(asset: SharedDesignSystemAsset.Assets.icHeart)
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
                
                Image(asset: isAdded ? SharedDesignSystemAsset.Assets.icAddedSelected : SharedDesignSystemAsset.Assets.icAdded)
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


