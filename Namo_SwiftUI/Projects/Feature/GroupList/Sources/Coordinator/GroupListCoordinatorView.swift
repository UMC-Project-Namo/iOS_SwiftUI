//
//  GroupListCoordinatorView.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureGatheringScheduleInterface

import ComposableArchitecture
import TCACoordinators

public struct GroupListCoordinatorView: View {
    let store: StoreOf<GroupListCoordinator>
    
    public init(store: StoreOf<GroupListCoordinator>) {
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
        }
    }
}


