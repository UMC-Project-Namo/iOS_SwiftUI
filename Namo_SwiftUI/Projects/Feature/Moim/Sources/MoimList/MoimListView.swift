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
                    VStack(spacing: 0) {
                        hidePastSchedule                        
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(store.filteredList) { moimSchedule in
                                    MoimScheduleCell(scheduleItem: moimSchedule)
                                        .onTapGesture {
                                            store.send(.moimCellSelected(meetingScheduleId: moimSchedule.meetingScheduleId))
                                        }
                                }
                            }
                            .padding(.horizontal, 25)
                        }
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
    
    private var hidePastSchedule: some View {
        HStack(spacing: 0) {
            Spacer()
            
            Text("지난 모임 일정 숨기기")
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.textDisabled)
            
            Image(asset: store.filter == .allSchedules ? SharedDesignSystemAsset.Assets.icCheck : SharedDesignSystemAsset.Assets.icCheckSelected)
                .padding(.leading, 8)
                .onTapGesture {
                    store.send(.toggleFilterOption)
                }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 12)
    }
}
