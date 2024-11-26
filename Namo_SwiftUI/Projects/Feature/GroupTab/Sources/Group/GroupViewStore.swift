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
        var isShowOverlay = false
    }
    
    public enum Action {
        case scheduleList(GatheringListStore.Action)
        case presentComposeSheet
        case reloadScheduleList
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.scheduleList, action: \.scheduleList) {
            GatheringListStore()
                ._printChanges()
        }
        
        Reduce { state, action in
            switch action {
            case .reloadScheduleList:
                return .send(.scheduleList(.loadSceduleList))
            default:
                return .none
            }
        }
    }
}
