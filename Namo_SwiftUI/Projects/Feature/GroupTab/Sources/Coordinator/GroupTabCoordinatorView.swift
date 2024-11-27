//
//  GroupListCoordinatorView.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureGatheringInterface

import ComposableArchitecture
import TCACoordinators

public struct GroupTabCoordinatorView: View {
    let store: StoreOf<GroupTabCoordinator>
    
    public init(store: StoreOf<GroupTabCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .group(store):
                    GroupView(store: store)
                case let .schedule(store):
                    ScheduleCoordinatorView(store: store)
                }
            }
            .overlay(store.isShowOverlay ? Color.black.opacity(0.3).ignoresSafeArea(.all) : nil)
        }
    }
}


