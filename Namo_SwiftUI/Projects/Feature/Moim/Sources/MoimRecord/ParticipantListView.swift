//
//  ParticipantListView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/15/24.
//

import SwiftUI

import SharedDesignSystem

struct ParticipantListView: View {
    let friendList: [String]    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .center) {
                Circle()
                    .frame(width: 42, height: 42)
                    .foregroundColor(Color.mainText)
                    .overlay {
                        Image(asset: SharedDesignSystemAsset.Assets.icCalendar)
                            .renderingMode(.template)
                            .foregroundColor(Color.white)
                    }
                
                ForEach(0..<10, id: \.self) { _ in
                    Text("코코아")
                        .font(.pretendard(.bold, size: 11))
                        .foregroundStyle(Color.mainText)
                        .background {
                            Circle()
                                .stroke(Color.mainText, lineWidth: 2)
                                .frame(width: 42, height: 42)
                        }
                        .padding(.horizontal, 8)
                }
            }
            .frame(height: 60)
        }
    }
}


