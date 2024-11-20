//
//  GatheringScheduleStoreInterface.swift
//  FeatureGatheringScheduleInterface
//
//  Created by 권석기 on 11/20/24.
//

import UIKit

import FeatureLocationSearchInterface

import ComposableArchitecture

@Reducer
public struct GatheringScheduleStore {
    
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        var title = ""
        var startDate = Date()
        var endDate = Date()
        var coverImage: UIImage?
        var isStartPickerPresented = false
        var isEndPickerPresented = false
        var kakaoMap: KakaoMapStore.State = .init()
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case kakaoMap(KakaoMapStore.Action)
        case cancleButtonTapped
        case goToLocationSearch
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.kakaoMap, action: \.kakaoMap) {
            KakaoMapStore()
        }
        reducer
    }
}
