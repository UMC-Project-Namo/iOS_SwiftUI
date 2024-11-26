//
//  MainTabCoordinatorView.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import SwiftUI

import Feature
import SharedDesignSystem

import ComposableArchitecture
import TCACoordinators

struct MainTabCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<MainTabCoordinator>
        
    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentTab) {
				HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
                    .tag(Tab.home)      
                
                GroupTabCoordinatorView(store: store.scope(state: \.group, action: \.group))
                    .tag(Tab.group)
            }
            .overlay(alignment: .bottom) {
                NamoTabView(currentTab: $store.currentTab)
            }
            .edgesIgnoringSafeArea(.bottom)
			.onAppear {
				store.send(.viewOnAppear)
			}
        }
    }
}

