//
//  MoimEditCoordinatorView.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/1/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

import SharedDesignSystem
import FeaturePlaceSearchInterface

public struct MoimEditCoordinatorView: View {
    let store: StoreOf<MoimEditCoordinator>
    
    public init(store: StoreOf<MoimEditCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .createMoim(store):
                MoimScheduleEditView(store: store)
            case let .kakaoMap(store):
                PlaceSearchView(store: store)
                .toolbar(.hidden, for: .navigationBar)
            }
        }
        .background(ClearBackground())
    }
}
