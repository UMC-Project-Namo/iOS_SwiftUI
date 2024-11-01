//
//  FriendRequestView.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import SwiftUI
import ComposableArchitecture
import SharedDesignSystem
import FeatureFriend

struct FriendRequestView: View {
    let store: StoreOf<FriendRequestListStore>
    
    var body: some View {
        FriendRequestListView(store: store)
            .namoNabBar(center: {
                Text("새로운 요청")
                    .font(.pretendard(.bold, size: 16))
            }, left: {
                NamoBackButton {                    
                }
            })
    }
}
