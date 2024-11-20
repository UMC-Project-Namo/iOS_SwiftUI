//
//  GroupViewStore.swift
//  FeatureGroupList
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import FeatureGatheringListInterface

import ComposableArchitecture

@Reducer
public struct GroupViewStore {
    @ObservableState
    public struct State: Equatable {
        public init() {}
        var gatherList: GatheringListStore.State = .init()
    }
    
    public enum Action {
        case gatherList(GatheringListStore.Action)
        case presentComposeSheet
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.gatherList, action: \.gatherList) {
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
