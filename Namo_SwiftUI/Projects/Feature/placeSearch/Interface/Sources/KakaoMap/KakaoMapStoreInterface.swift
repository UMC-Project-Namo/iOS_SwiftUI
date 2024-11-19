//
// KakaoMapStoreInterface.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 11/19/24.
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
        
        public var currentPoiID: String = ""
        
        /// 경도
        public var longitude: Double = 0.0
        
        /// 위도
        public var latitude: Double = 0.0
        
        /// 검색결과 리스트
        public var placeList: [LocationInfo] = []
    }
    
    public enum Action: Equatable {
        /// poi 클릭시 id받기
        case poiTapped(poiID: String)
        case createPoi(longitude: Double, latitude: Double)
    }
    
    public var body: some ReducerOf<Self> {
        
        reducer
    }
}
