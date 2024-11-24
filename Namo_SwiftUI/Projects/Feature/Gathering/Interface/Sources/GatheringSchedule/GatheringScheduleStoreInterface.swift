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
public struct GatheringScheduleStore {
    public enum EditMode {
        case view, edit, compose
    }
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        public var editMode: EditMode = .compose
        public var scheduleId = 0
        public var title = ""
        public var startDate = Date()
        public var endDate = Date()
        public var imageUrl = ""
        public var coverImage: UIImage?        
        public var coverImageItem: PhotosPickerItem?
        public var isStartPickerPresented = false
        public var isEndPickerPresented = false
        public var kakaoMap: KakaoMapStore.State = .init()
        public var friendList: FriendInviteStore.State = .init()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectedImage(UIImage)
        case kakaoMap(KakaoMapStore.Action)
        case friendList(FriendInviteStore.Action)
        case startPickerTapped
        case endPickerTapped
        case createButtonTapped
        case createButtonConfirm
        case cancleButtonTapped
        case goToLocationSearch
        case goToFriendInvite
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.kakaoMap, action: \.kakaoMap) {
            KakaoMapStore()
        }        
        Scope(state: \.friendList, action: \.friendList) {
            FriendInviteStore()
        }
        reducer
    }
}
