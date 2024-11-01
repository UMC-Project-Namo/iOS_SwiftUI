//
//  MoimViewStore.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/25/24.
//

import Foundation
import ComposableArchitecture
import FeatureMoimInterface
import DomainMoimInterface
import FeatureFriend
import DomainFriend

@Reducer
public struct MainViewStore {
    @Dependency(\.moimUseCase) var moimUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(moimListStore: .init(),
                                               friendListStore: .init(),
                                               moimEditStore: .init())
        
        // 현재 선택한탭
        public var currentTab = 0
        
        // 일정생성뷰
        public var isSheetPresented = false
        
        // 모임리스트
        var moimListStore: MoimListStore.State
        
        // 친구리스트
        var friendListStore: FriendListStore.State
        
        // 모임생성
        var moimEditStore: MoimEditStore.State
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case moimListAction(MoimListStore.Action)
        case moimEditAction(MoimEditStore.Action)
        case friendListAction(FriendListStore.Action)        
        case notificationButtonTap
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.moimListStore, action: \.moimListAction) {
            MoimListStore()
        }
        Scope(state: \.friendListStore, action: \.friendListAction) {
            FriendListStore()
        }
        Scope(state: \.moimEditStore, action: \.moimEditAction) {
            MoimEditStore()
        }
        
        Reduce<State, Action> { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
