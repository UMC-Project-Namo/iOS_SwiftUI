//
//  ScheduleCoordinatorView.swift
//  FeatureGatheringSchedule
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureFriendInviteInterface
import FeatureLocationSearchInterface
import FeatureFriendInvite

import ComposableArchitecture
import TCACoordinators

public struct ScheduleCoordinatorView: View {
    let store: StoreOf<ScheduleCoordinator>
    
    public init(store: StoreOf<ScheduleCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .scheduleEdit(store):
                    ScheduleEditView(store: store)
                case let .locationSearch(store):
                    LocationSearchView(store: store)
                case let .friendInvite(store):
                    FriendInviteView(store: store)
                }
            }
        }
    }
}

