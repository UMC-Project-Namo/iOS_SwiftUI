//
//  PlaceSearchInterface.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 10/20/24.
//

import Foundation
import ComposableArchitecture
import DomainPlaceSearchInterface

@Reducer
public struct PlaceSearchStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}                                              
                
        /// 고유 id(poiID로 사용)
        public var id: String = ""
        
        /// 경도
        public var x: Double = 0.0
        
        /// 위도
        public var y: Double = 0.0
        
        /// 장소이름
        public var locationName: String = ""
        
        /// 검색어
        public var searchText: String = ""
        
        /// 검색결과 리스트
        public var placeList: [LocationInfo] = []
                
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        /// 검색버튼 탭(비동기)
        case searchButtonTapped
        
        /// 검색결과 응답
        case responsePlaceList([LocationInfo])
        
        ///  위치핀 탭
        case poiTapped(String)    
        
        /// 뒤로가기
        case backButtonTapped
        
        /// 위치 업데이트
        case locationUpdated(LocationInfo)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        reducer
    }
}
