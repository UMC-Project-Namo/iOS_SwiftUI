//
//  OnboardingTOSView.swift
//  FeatureOnboarding
//
//  Created by 박민서 on 9/13/24.
//

import SwiftUI
import SharedDesignSystem
import ComposableArchitecture
import Combine

public struct OnboardingTOSView: View {
    
    @Dependency(\.locationManager) var locationManager
    
    public let store: StoreOf<OnboardingTOSStore>
    @State private var cancellables: Set<AnyCancellable> = []
    
    public init(store: StoreOf<OnboardingTOSStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 56) {
                
                Spacer()
                
                Text("서비스 이용을 위한 ")
                    .foregroundColor(.colorBlack)
                    .font(Font.pretendard(.regular, size: 18))
                + Text("약관 동의")
                    .foregroundColor(.colorBlack)
                    .font(Font.pretendard(.bold, size: 18))
                
                TOSListView(store: store)
                
                Spacer()
                
                NamoButton(title: "확인", type: store.nextButtonIsEnabled ? .active : .inactive, action: {
                    store.send(.nextButtonTapped)
                })
                .padding(.horizontal, 25)
                
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            locationManager.authorizationStatusPublisher
                .sink { status in
                    store.send(.authorizationStatusUpdated(status))
                }
                .store(in: &cancellables)
        }
    }
}
