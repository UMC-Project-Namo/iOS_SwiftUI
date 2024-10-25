//
//  OnboardingSplashStore.swift
//  FeatureOnboarding
//
//  Created by 박민서 on 9/18/24.
//

import ComposableArchitecture
import SharedUtil
import UIKit

@Reducer
public struct OnboardingSplashStore {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        /// 앱 스타팅 체크 로직  플래그
        var isChecking: Bool = false
        /// 업데이트 필요 표시 플래그
        @Shared(.inMemory(SharedKeys.showUpdateRequired.rawValue)) var showUpdateRequired: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        /// 앱 업데이트하기 버튼 탭
        case goUpdateButtonTapped
        /// 앱 업데이트 취소 버튼 탭
        case cancelUpdateButtonTapped
    }
    
    /// 타이머
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(_):
                return .none
                
            case .goUpdateButtonTapped:
                print("go to app store")
                if let url = URL(string: SecretConstants.namoAppStoreURL),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                return .none
                
            case .cancelUpdateButtonTapped:
                print("exit this app")
                return .none
            }
        }
    }
}
