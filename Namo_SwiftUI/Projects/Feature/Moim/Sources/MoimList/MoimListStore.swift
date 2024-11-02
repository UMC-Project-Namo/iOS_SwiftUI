//
//  MoimListStore.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/25/24.
//

import Foundation
import ComposableArchitecture

import FeatureMoimInterface
import Domain

extension MoimListStore {
    public init() {
        @Dependency(\.moimUseCase) var moimUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
                // 뷰가 로드되면 모임리스트 요청
            case .viewOnAppear:
                return .run { send in
                    let result = try await moimUseCase.getMoimList()
                    await send(.moimListResponse(result))
                }
                // 모임리스트 요청 결과 스토어 업데이트
            case let  .moimListResponse(moimList):
                state.moimList = moimList                
                return .none
                // 모임셀 선택
            case let .moimCellSelected(meetingScheduleId):
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
