//
//  GatheringScheduleStore.swift
//  FeatureGatheringScheduleInterface
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI
import UIKit

import DomainMoimInterface
import DomainMoim

import ComposableArchitecture

extension GatheringRootStore {
    public init() {
        @Dependency(\.moimUseCase) var moimUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {                
            case .createButtonTapped:
                return .run { [state = state] send in
                    if state.editMode == .compose {
                        try await moimUseCase.createMoim(state.makeSchedule(), state.schedule.coverImage)
                    } else {
                        try await moimUseCase.editMoim(state.makeSchedule(), state.schedule.coverImage)
                    }
                    await send(.createButtonConfirm)
                }
            default:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}

extension GatheringRootStore.State {
    func makeSchedule() -> MoimSchedule {
        .init(scheduleId: schedule.scheduleId,
              title: schedule.title,
              imageUrl: schedule.imageUrl,
              startDate: schedule.startDate,
              endDate: schedule.endDate,
              longitude: kakaoMap.longitude,
              latitude: kakaoMap.latitude,
              locationName: kakaoMap.locationName,
              kakaoLocationId: kakaoMap.kakaoLocationId,
              participants: friendList.addedFriendList.map { .init(participantId: 0,
                                                                   userId: $0.memberId,
                                                                   isGuest: false,
                                                                   nickname: $0.nickname,
                                                                   colorId: $0.favoriteColorId,
                                                                   isOwner: false)
        })
    }
}

