//
//  GroupViewStore.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import FeatureGatheringInterface

import ComposableArchitecture

@Reducer
public struct GroupViewStore {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var scheduleList: GatheringListStore.State = .init()        
    }
    
    public enum Action {
        case scheduleList(GatheringListStore.Action)
        case presentComposeSheet
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.scheduleList, action: \.scheduleList) {
            GatheringListStore()
        }
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
