//
//  OnBoardingCoordinatorView.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators
import FeatureOnboarding

struct OnboardingCoordinatorView: View {
    let store: StoreOf<OnboardingCoordinator>
    
    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
                
            case let .splash(store):
                OnboardingSplashView(store: store)
            case let .login(store):
                OnboardingLoginView(store: store)
                    .toolbar(.hidden)
            case let .agreement(store):
                OnboardingTOSView(store: store)
                    .toolbar(.hidden)
            case let .userInfo(store):
                OnboardingInfoInputView(store: store)
                    .toolbar(.hidden)
            case let .signUpCompletion(store):
                OnboardingCompleteView(store: store)
                    .toolbar(.hidden)
            }
        }
        .onAppear {
            store.send(.initialCheck)
        }
    }
}
