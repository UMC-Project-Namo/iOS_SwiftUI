//
//  PlaceSearchStore.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 10/20/24.
//

import Foundation

import DomainPlaceSearch
import ComposableArchitecture

public extension PlaceSearchStore {
    public init() {
        @Dependency(\.placeUseCase) var placeUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case let .kakaoMap(.poiTapped(poiID)):
                guard let selectedPlace = state.searchList.first(where: {$0.id == poiID }),
                      let latitude = Double(selectedPlace.y),
                      let longitude = Double(selectedPlace.x) else {
                    return .none
                }
                state.kakaoMap.latitude = latitude
                state.kakaoMap.longitude = longitude
                state.kakaoMap.currentPoiID = selectedPlace.id
                state.currentPlace = selectedPlace
                return .none
            case let .searchResultTapped(poiID):
                guard let selectedPlace = state.searchList.first(where: {$0.id == poiID }),
                      let latitude = Double(selectedPlace.y),
                      let longitude = Double(selectedPlace.x) else {
                    return .none
                }
                state.kakaoMap.latitude = latitude
                state.kakaoMap.longitude = longitude
                state.kakaoMap.currentPoiID = selectedPlace.id
                state.currentPlace = selectedPlace
                return .none
            case .searchButtonTapped:
                return .run { [state = state] send in
                    let placeList = try await placeUseCase.getSearchList(state.searchText)
                    await send(.responsePlaceList(placeList))
                }
            case let .responsePlaceList(placeList):
                state.searchList = placeList
                state.kakaoMap.placeList = placeList
                return .none
                
            default:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
