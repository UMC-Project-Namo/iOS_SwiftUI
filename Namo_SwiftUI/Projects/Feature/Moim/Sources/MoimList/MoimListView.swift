//
//  MoimListView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/25/24.
//

import SwiftUI

import DomainMoimInterface
import FeatureMoimInterface
import SharedDesignSystem

import ComposableArchitecture

struct MoimListView: View {
    let store: StoreOf<MoimListStore>
    
    public init(store: StoreOf<MoimListStore>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            
            ZStack {
                if !store.moimList.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(store.moimList) { moimSchedule in
                                MoimScheduleCell(scheduleItem: moimSchedule)
                                    .onTapGesture {
                                        store.send(.moimCellSelected(meetingScheduleId: moimSchedule.meetingScheduleId))
                                    }
                            }
                        }
                        .padding(20)
                    }
                } else {
                    EmptyListView(title: "모임 일정이 없습니다.\n 친구와의 모임 약속을 잡아보세요!")
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(alignment: .bottomTrailing) {
                FloatingButton {
                    store.send(.presentComposeSheet)
                }
            }         
            .onAppear {               
                store.send(.viewOnAppear)
            }
        }
    }
}
