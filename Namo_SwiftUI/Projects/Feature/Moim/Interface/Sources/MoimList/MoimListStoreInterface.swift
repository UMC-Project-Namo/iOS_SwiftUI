//
//  MoimListStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/25/24.
//

import Foundation
import ComposableArchitecture
import DomainMoimInterface

@Reducer
public struct MoimListStore {
    
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        public var moimList: [MoimScheduleItem] = []
    }
    
    public enum Action {
        case viewOnAppear
        case moimListResponse([MoimScheduleItem])
        case moimCellSelected(meetingScheduleId: Int)
        case presentComposeSheet
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
