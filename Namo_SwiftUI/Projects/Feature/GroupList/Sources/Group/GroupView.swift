//
//  GroupView.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureGatheringListInterface

import ComposableArchitecture

struct GroupView: View {
    let store: StoreOf<GroupViewStore>
    
    var body: some View {
        GatheringListView(store: store.scope(
            state: \.gatherList,
            action: \.gatherList)
        )
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                store.send(.presentComposeSheet)
            }, label: {
                Text("add")
            })
            .padding(10)
        }
    }
}

