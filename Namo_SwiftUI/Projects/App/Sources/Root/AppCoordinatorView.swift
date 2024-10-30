//
//  AppCoordinatorView.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators
import Combine
import SharedDesignSystem
import SharedUtil

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .mainTab(store):
                MainTabCoordinatorView(store: store)
            case let .onboarding(store):
                OnboardingCoordinatorView(store: store)
            }
        }
        .namoAlertView(
            isPresented: Binding(get: { store.showAlert }, set: { store.send(.changeShowAlert(show: $0)) }),
            title: store.alertTitle,
            content: store.alertContent,
            confirmAction: {
                store.send(.doAlertConfirmAction)
            }
        )
        .onReceive(NotificationCenter.default.publisher(for: .networkError)) { notification in
            if let error = notification.userInfo?["error"] as? NetworkErrorNotification {
                store.send(.handleNotiError(error: error))
            }
        }
    }
}
