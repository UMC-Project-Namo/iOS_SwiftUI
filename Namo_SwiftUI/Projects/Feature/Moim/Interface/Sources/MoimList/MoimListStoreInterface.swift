//
//  MoimListStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/25/24.
//

import Foundation

import DomainMoimInterface

import ComposableArchitecture

/**
 Reducer for MoimList(일정 목록조회) Feature
*/
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
        
        /// viewOnAppear
        case viewOnAppear
        
        /// 모임결과 응답
        case moimListResponse([MoimScheduleItem])
        
        /// 모임셀 선택
        case moimCellSelected(meetingScheduleId: Int)
        
        /// 일정 생성
        case presentComposeSheet
        
        /// 일정 조회
        case presentDetailSheet(MoimSchedule)
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
