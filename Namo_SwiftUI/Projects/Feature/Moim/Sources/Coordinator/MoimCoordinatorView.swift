//
//  MoimCoordinatorView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/21/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

import FeaturePlaceSearch
import FeatureFriend
import SharedDesignSystem

public struct MoimCoordinatorView: View {
    let store: StoreOf<MoimCoordinator>
    
    public init(store: StoreOf<MoimCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .mainTab(store):
                MainView(store: store)                    
            case let .moimEdit(store):
                MoimEditCoordinatorView(store: store)
            case .notification:
                Text("친구요청")
            }
        }
        .overlay(store.isPresentedSheet ? Color.black.opacity(0.3).ignoresSafeArea(.all) : nil)
    }
}

