//
//  GatheringCell.swift
//  FeatureGathering
//
//  Created by 권석기 on 11/26/24.
//

import SwiftUI

import DomainMoimInterface
import SharedDesignSystem

import Kingfisher

public struct GatheringCell: View {
    private let schedule: MoimScheduleItem
    
    public init(schedule: MoimScheduleItem) {
        self.schedule = schedule
    }
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                KFImage(URL(string: schedule.imageUrl))
                    .placeholder({
                        Image(asset: SharedDesignSystemAsset.Assets.moimDefaultImage)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(schedule.startDate)
                        .font(.pretendard(.regular, size: 12))
                        .foregroundStyle(Color.mainText)
                    
                    
                    Text(schedule.title)
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    HStack {
                        Text("\(schedule.participantCount)")
                            .font(.pretendard(.bold, size: 12))
                            .foregroundStyle(Color.mainText)
                        
                        Text(schedule.participantNicknames)
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

