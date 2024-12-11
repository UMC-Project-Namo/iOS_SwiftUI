//
//  GroupView.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureFriend
import FeatureGatheringInterface
import SharedDesignSystem

import ComposableArchitecture

struct GroupView: View {
    @Perception.Bindable var store: StoreOf<GroupViewStore>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                TabBarView(currentTab: $store.currentTab, tabBarOptions: ["모임 일정", "친구리스트"])
                
                TabView(selection: $store.currentTab) {
                    GatheringListView(store: store.scope(
                        state: \.scheduleList,
                        action: \.scheduleList)
                    )
                    .overlay(alignment: .bottomTrailing) {
                        FloatingButton(action: {
                            store.send(.presentComposeSheet)
                        })
                    }
                    .tag(0)
                    
                    FriendListView(
                        store: store.scope(
                            state: \.friendList,
                            action: \.friendList
                        )
                    )
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .namoNabBar(
                left: {
                    Text("Group Calendar")
                        .font(.pretendard(.bold, size: 22))
                        .foregroundStyle(Color.black)
                },
                right: {
                    Button(action: {
                        
                    }) {
                        Image(asset: SharedDesignSystemAsset.Assets.icNotification)
                    }
                }
            )            
        }
    }
}


struct TabBarView: View {
    @Binding public var currentTab: Int
    @Namespace var namespace
    
    public let tabBarOptions: [String]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                Spacer()
                ForEach(Array(tabBarOptions.enumerated()), id: \.self.0) { index, item in
                    Button(action: {
                        withAnimation {
                            currentTab = index
                        }
                    }, label: {
                        VStack(spacing: 8) {
                            let isSelected = currentTab == index
                            Text(item)
                                .font(.pretendard(.bold, size: 15))
                                .foregroundStyle(isSelected ? Color.namoOrange : Color.textPlaceholder)
                                .padding(.horizontal, 10)
                            
                            if isSelected {
                                Color.namoOrange
                                    .frame(height: 1)
                                    .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                            } else {
                                Color.clear
                                    .frame(height: 1)
                            }
                        }
                        .fixedSize()
                        .animation(.spring, value: currentTab)
                    })
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .zIndex(10)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(Color.mainGray)
        }
        .background(.white)
        
    }
}
