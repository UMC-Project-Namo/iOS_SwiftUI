//
//  GarheringListStoreInterface.swift
//  FeatureGatheringList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import DomainMoimInterface

import ComposableArchitecture

@Reducer
public struct GatheringListStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public enum FilterOption {
        case allSchedules, hidePastSchedules
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        public var scheduleList: IdentifiedArrayOf<MoimScheduleItem> = []
        public var filter: FilterOption = .allSchedules
        public var filteredList: IdentifiedArrayOf<MoimScheduleItem> {
            switch filter {
            case .allSchedules:
                scheduleList
            case .hidePastSchedules:
                scheduleList
            }
        }
    }
    
    public enum Action {
        case loadSceduleList
        case scheduleCellSelected(meetingScheduleId: Int)
        case presentDetailSheet(MoimSchedule)
        case responseSceduleList(IdentifiedArrayOf<MoimScheduleItem>)
        case toggleFilterOption
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
