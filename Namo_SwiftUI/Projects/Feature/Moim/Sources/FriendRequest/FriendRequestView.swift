//
//  FriendRequestView.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import SwiftUI
import SharedDesignSystem

struct FriendRequestView: View {
    var body: some View {
        Text("친구 요청")
            .namoNabBar(center: {
                Text("새로운 요청")
                    .font(.pretendard(.bold, size: 16))
            }, left: {
                NamoBackButton {
                    
                }
            })
    }
}

#Preview {
    FriendRequestView()
}
