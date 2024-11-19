//
//  PlaceSearchInterface.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 10/20/24.
//

import Foundation

import DomainPlaceSearchInterface

import ComposableArchitecture

@Reducer
public struct PlaceSearchStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.kakaoMap = .init()
        }
        
        public var kakaoMap: KakaoMapStore.State
                
        public var searchText: String = ""
        
        public var currentPlace: LocationInfo?
        
        public var searchList: [LocationInfo] = []
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case kakaoMap(KakaoMapStore.Action)
        case responsePlaceList([LocationInfo])
        case searchButtonTapped
        case searchResultTapped(poiID: String)
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
