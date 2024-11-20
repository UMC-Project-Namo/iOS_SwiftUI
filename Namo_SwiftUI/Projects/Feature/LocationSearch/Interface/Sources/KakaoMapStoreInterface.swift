//
//  KakaoMapStoreInterface.swift
//  FeatureLocationSearch
//
//  Created by 권석기 on 11/21/24.
//

import Foundation

import DomainPlaceSearchInterface

import ComposableArchitecture

@Reducer
public struct KakaoMapStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        static let initialState = State()
        public init() {}
        
        public var kakaoLocationId = ""
        public var longitude = 0.0
        public var latitude = 0.0
        public var locationName = ""
        public var placeList: [LocationInfo] = []
    }
    
    public enum Action: Equatable {
        case poiTapped(poiID: String)
        case createPoi(longitude: Double, latitude: Double)
    }
    
    public var body: some ReducerOf<Self> {
        
        reducer
    }
}
