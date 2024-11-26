//
//  GatheringStore.swift
//  FeatureGathering
//
//  Created by 권석기 on 11/25/24.
//

import Foundation
import UIKit

import ComposableArchitecture

extension GatheringStore {
    public init() {
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
            default:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
