//
//  GatheringScheduleStoreInterface.swift
//  FeatureGatheringScheduleInterface
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI
import UIKit
import PhotosUI

import FeatureLocationSearchInterface
import FeatureFriendInviteInterface

import ComposableArchitecture

@Reducer
public struct GatheringRootStore {
    public enum EditMode {
        case view, edit, compose
    }
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init(editMode: EditMode = .compose, schedule: GatheringStore.State = .init(),
                    kakaoMap: KakaoMapStore.State = .init(),
                    friendInvite: FriendInviteStore.State = .init()) {
            self.editMode = editMode
            self.schedule = schedule
            self.kakaoMap = kakaoMap
            self.friendList = friendInvite
        }
        
        public var editMode: EditMode
        public var showingDeleteAlert = false
        public var schedule: GatheringStore.State
        public var kakaoMap: KakaoMapStore.State
        public var friendList: FriendInviteStore.State
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)        
        case kakaoMap(KakaoMapStore.Action)
        case friendList(FriendInviteStore.Action)
        case schedule(GatheringStore.Action)
        case createButtonTapped
        case createButtonConfirm
        case cancleButtonTapped
        case deleteButtonTapped
        case deleteButtonConfirm
        case deleteCompleted
        case goToLocationSearch
        case goToFriendInvite
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.schedule, action: \.schedule) {
            GatheringStore()
        }
        Scope(state: \.friendList, action: \.friendList) {
            FriendInviteStore()
        }
        reducer
    }
}
