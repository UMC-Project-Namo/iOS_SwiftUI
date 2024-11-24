//
//  GatheringListStore.swift
//  FeatureGatheringList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import Domain

import ComposableArchitecture

public extension GatheringListStore {
    init() {
        @Dependency(\.moimUseCase) var moimUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case .loadSceduleList:
                return .run { send in
                    let result = try await moimUseCase.getMoimList()
                    let scheduleList = IdentifiedArray(uniqueElements: result)
                    await send(.responseSceduleList(scheduleList))
                }
            case let .responseSceduleList(scheduleList):
                state.scheduleList = scheduleList
                return .none
            case let .scheduleCellSelected(meetingScheduleId):
                return .run { send in
                    let moimSchedule = try await moimUseCase.getMoimDetail(meetingScheduleId)
                    await send(.presentDetailSheet(moimSchedule))
                }
            default:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
