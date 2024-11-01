//
//  MainTabCoordinatorView.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators
import Feature

struct MainTabCoordinatorView: View {
    let store: StoreOf<MainTabCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            TabView {
//				HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
//					.tabItem { Text("홈") }
				
                MoimCoordinatorView(store: store.scope(state: \.moim, action: \.moim))
                    .tabItem { Text("모임") }
            }
			.onAppear {
				store.send(.viewOnAppear)
			}
        }
    }
}

