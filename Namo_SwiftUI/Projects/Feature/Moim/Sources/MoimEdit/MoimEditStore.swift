//
//  MoimScheduleStore.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/24/24.
//

import SwiftUI
import UIKit
import ComposableArchitecture
import FeatureMoimInterface
import DomainMoimInterface
import SharedUtil

extension MoimEditStore {
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
                    if state.mode == .compose {
                        try await moimUseCase.createMoim(state.makeMoim(), state.coverImage)
                    } else {
                        try await moimUseCase.editMoim(state.makeMoim(), state.coverImage)
                    }
                }
            case .deleteButtonTapped:
                state.isAlertPresented = true
                return .none
            case .deleteButtonConfirm:
                return .run { [state = state] send in
                    try await moimUseCase.withdrawMoim(state.moimScheduleId)
                }         
            default:                
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}

extension MoimEditStore.State {
    func makeMoim() -> MoimSchedule {
        .init(scheduleId: moimScheduleId,
              title: title,
              imageUrl: imageUrl,
              startDate: startDate,
              endDate: endDate,
              longitude: longitude,
              latitude: latitude,
              locationName: locationName,
              kakaoLocationId: kakaoLocationId,
              participants: [])
    }
}



