//
//  GroupViewStore.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import DomainFriend
import FeatureFriend
import FeatureGatheringInterface

import ComposableArchitecture

@Reducer
public struct GroupViewStore {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var scheduleList: GatheringListStore.State = .init()
        var friendList: FriendListStore.State = .init()
        var currentTab = 0
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case scheduleList(GatheringListStore.Action)
        case friendList(FriendListStore.Action)
        case presentComposeSheet
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.scheduleList, action: \.scheduleList) {
            GatheringListStore()
        }
        Scope(state: \.friendList, action: \.friendList) {
            FriendListStore()
        }
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
