//
//  GarheringListView.swift
//  FeatureGatheringList
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import SharedDesignSystem

import ComposableArchitecture

public struct GatheringListView: View {
    let store: StoreOf<GatheringListStore>
    
    public init(store: StoreOf<GatheringListStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                if store.scheduleList.isEmpty {
                    EmptyListView(title: "모임 일정이 없습니다.\n 친구와의 모임 약속을 잡아보세요!")
                } else {
                    filterButton
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(store.filteredList) { schedule in
                                GatheringCell(schedule: schedule)
                                    .onTapGesture {
                                        store.send(.scheduleCellSelected(meetingScheduleId: schedule.meetingScheduleId))
                                    }
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                }
            }
        }
        .onAppear {
            store.send(.loadSceduleList)
        }
    }
}

extension GatheringListView {
    private var filterButton: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("지난 모임 일정 숨기기")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.textDisabled)
            
            Image(asset: SharedDesignSystemAsset.Assets.icCheckSelected)
                .padding(.leading, 8)
                .onTapGesture {
                    store.send(.toggleFilterOption)
                }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 12)
    }
}
