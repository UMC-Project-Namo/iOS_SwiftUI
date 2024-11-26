//
//  GarheringListView.swift
//  FeatureGatheringList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import ComposableArchitecture

public struct GatheringListView: View {
    let store: StoreOf<GatheringListStore>
    
    public init(store: StoreOf<GatheringListStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(store.scheduleList) { schedule in
                        GatheringCell(schedule: schedule)
                            .onTapGesture {
                                store.send(.scheduleCellSelected(meetingScheduleId: schedule.meetingScheduleId))
                            }
                    }
                }
                .padding(.horizontal, 25)
            }
        }
        .onAppear {
            store.send(.loadSceduleList)
        }
    }
}
