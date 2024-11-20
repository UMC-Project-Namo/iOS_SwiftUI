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
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var scheduleList: IdentifiedArrayOf<MoimScheduleItem> = []
    }
    
    public enum Action {
        case loadSceduleList
        case scheduleCellSelected(meetingScheduleId: Int)
        case responseSceduleList(IdentifiedArrayOf<MoimScheduleItem>)
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
