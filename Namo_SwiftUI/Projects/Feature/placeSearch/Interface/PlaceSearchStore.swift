//
//  PlaceSearchStore.swift
//  FeaturePlaceSearchInterface
//
//  Created by 권석기 on 10/20/24.
//

import Foundation
import FeaturePlaceSearchInterface
import DomainPlaceSearch
import ComposableArchitecture

public extension PlaceSearchStore {
    public init() {
        @Dependency(\.placeUseCase) var placeUseCase
        
        let reducer: Reduce<State, Action> = Reduce { state, action in
            switch action {
            case .searchButtonTapped:
                return .run { [state = state] send in
                    let placeList = try await placeUseCase.getSearchList(state.searchText)
                    await send(.responsePlaceList(placeList))
                }
            case let .responsePlaceList(placeList):
                state.placeList = placeList
                return .none
            case let .poiTapped(poiID):
                state.id = poiID
                return .none
            case .viewOnAppear:
                state.draw = true
                return .none
            case .viewOnDisappear:
                state.draw = false
                return .none
            default:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
