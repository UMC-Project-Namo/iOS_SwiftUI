//
//  MoimListCell.swift
//  FeatureMoimInterface
//
//  Created by 권석기 on 9/10/24.
//

import SwiftUI

import DomainMoimInterface
import SharedDesignSystem

import Kingfisher

struct MoimScheduleCell: View {
    private let scheduleItem: MoimScheduleItem
    
    init(scheduleItem: MoimScheduleItem) {
        self.scheduleItem = scheduleItem
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                KFImage(URL(string: scheduleItem.imageUrl))
                    .placeholder({
                        Image(asset: SharedDesignSystemAsset.Assets.moimDefaultImage)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(scheduleItem.startDate)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(Color.mainText)
                    
                    
                    Text(scheduleItem.title)
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    HStack {
                        Text("\(scheduleItem.participantCount)")
                            .font(.pretendard(.bold, size: 12))
                            .foregroundStyle(Color.mainText)
                        
                        Text(scheduleItem.participantNicknames)
                            .font(.pretendard(.regular, size: 12))
                            .foregroundStyle(Color.mainText)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Image(asset: SharedDesignSystemAsset.Assets.btnAddRecord)
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .background(Color.itemBackground)
        .cornerRadius(8)
        .shadow(
            color: Color.black.opacity(0.1),
            radius: 2
        )
    }
}

