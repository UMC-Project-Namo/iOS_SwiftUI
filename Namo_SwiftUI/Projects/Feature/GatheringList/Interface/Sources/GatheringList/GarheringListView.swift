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
            List(store.scheduleList) { schedule in
                VStack {
                    Text("\(schedule.startDate)")
                    Text("\(schedule.title)")
                    Text("\(schedule.participantCount)")
                    Text("\(schedule.participantNicknames)")
                }
            }
        }
        .onAppear {            
            store.send(.loadSceduleList)
        }
    }
}
