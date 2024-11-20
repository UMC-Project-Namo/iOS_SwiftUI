//
//  LocationSearchStore.swift
//  FeatureLocationSearch
//
//  Created by 권석기 on 11/20/24.
//

import Foundation

import DomainPlaceSearch

import ComposableArchitecture

extension LocationSearchStore {
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
                state.kakaoMap.kakaoLocationId = selectedPlace.id      
                state.kakaoMap.locationName = selectedPlace.placeName
                return .send(.updatedLocation(state.kakaoMap))
            case let .searchResultTapped(poiID):
                guard let selectedPlace = state.searchList.first(where: {$0.id == poiID }),
                      let latitude = Double(selectedPlace.y),
                      let longitude = Double(selectedPlace.x) else {
                    return .none
                }
                state.kakaoMap.latitude = latitude
                state.kakaoMap.longitude = longitude
                state.kakaoMap.kakaoLocationId = selectedPlace.id
                state.kakaoMap.locationName = selectedPlace.placeName
                return .send(.updatedLocation(state.kakaoMap))
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
