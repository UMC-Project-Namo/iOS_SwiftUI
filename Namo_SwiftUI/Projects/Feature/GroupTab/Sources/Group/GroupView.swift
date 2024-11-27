//
//  GroupView.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureGatheringInterface
import SharedDesignSystem

import ComposableArchitecture

struct GroupView: View {
    let store: StoreOf<GroupViewStore>
    
    var body: some View {
        WithPerceptionTracking {
            GatheringListView(store: store.scope(
                state: \.scheduleList,
                action: \.scheduleList)
            )
            .overlay(alignment: .bottomTrailing) {
                FloatingButton(action: {
                    store.send(.presentComposeSheet)
                })
            }            
        }
    }
}

