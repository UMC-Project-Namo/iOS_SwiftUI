//
//  LocationSearchStoreInterface.swift
//  FeatureLocationSearch
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import DomainPlaceSearchInterface

import ComposableArchitecture

@Reducer
public struct LocationSearchStore {
    
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        public var kakaoMap: KakaoMapStore.State = .init()
        public var searchText: String = ""
        public var searchList: [LocationInfo] = []
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case kakaoMap(KakaoMapStore.Action)
        case responsePlaceList([LocationInfo])
        case locationUpdated(LocationInfo)
        case updatedLocation(KakaoMapStore.State)
        case searchResultTapped(poiID: String)
        case searchButtonTapped
        case backButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.kakaoMap, action: \.kakaoMap) {
            KakaoMapStore()
        }
        reducer
    }
}
