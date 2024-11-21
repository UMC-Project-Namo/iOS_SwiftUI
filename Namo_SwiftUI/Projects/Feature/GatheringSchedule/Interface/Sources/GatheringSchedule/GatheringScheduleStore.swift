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

extension GatheringScheduleStore {
    public init() {
        @Dependency(\.moimUseCase) var moimUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case .binding(\.coverImageItem):
                return .run { [imageItem = state.coverImageItem] send in
                    if let loaded = try? await imageItem?.loadTransferable(type: Data.self) {
                        guard let uiImage = UIImage(data: loaded) else {
                            return
                        }
                        await send(.selectedImage(uiImage))
                    }
                }
            case let .selectedImage(image):
                state.coverImage = image
                return .none
            case .startPickerTapped:
                state.isStartPickerPresented.toggle()
                return .none
                
            case .endPickerTapped:
                state.isEndPickerPresented.toggle()
                return .none
            case .createButtonTapped:
                return .run { [state = state] send in
                    if state.editMode == .compose {
                        try await moimUseCase.createMoim(state.makeSchedule(), state.coverImage)
                    } else {
                        try await moimUseCase.editMoim(state.makeSchedule(), state.coverImage)
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

extension GatheringScheduleStore.State {
    func makeSchedule() -> MoimSchedule {
        .init(scheduleId: scheduleId,
              title: title,
              imageUrl: imageUrl,
              startDate: startDate,
              endDate: endDate,
              longitude: kakaoMap.longitude,
              latitude: kakaoMap.latitude,
              locationName: kakaoMap.locationName,
              kakaoLocationId: kakaoMap.kakaoLocationId,
              participants: [])
    }
}

