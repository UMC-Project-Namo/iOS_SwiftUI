//
//  MoimView.swift
//  FeatureMoimInterface
//
//  Created by 권석기 on 9/6/24.
//

import SwiftUI

import FeatureFriend
import FeatureMoimInterface
import SharedDesignSystem

import ComposableArchitecture

public struct MainView: View {
    @Perception.Bindable private var store: StoreOf<MainViewStore>
    
    public init(store: StoreOf<MainViewStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                TabBarView(currentTab: $store.currentTab, tabBarOptions: ["모임 일정", "친구리스트"])
               
                TabView(selection: $store.currentTab) {
                   
                    MoimListView(
                        store: store.scope(
                            state: \.moimListStore,
                            action: \.moimListAction
                        )
                    )                    
                    .tag(0)
                    
                    FriendListView(
                        store: store.scope(
                            state: \.friendListStore,
                            action: \.friendListAction
                        )
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }            
            .namoNabBar(left: {
                Text("Group Calendar")
                    .font(.pretendard(.bold, size: 22))
                    .foregroundStyle(.black)
            }, right: {
                Button(action: {
                    store.send(.notificationButtonTap)
                }) {
                    Image(asset: SharedDesignSystemAsset.Assets.icNotification)
                }
            })
        }
    }
}
