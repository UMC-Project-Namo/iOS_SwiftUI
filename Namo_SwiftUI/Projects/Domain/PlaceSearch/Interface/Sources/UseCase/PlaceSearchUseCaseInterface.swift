//
//  PlaceSearchUseCaseInterface.swift
//  DomainPlaceSearch
//
//  Created by 권석기 on 10/20/24.
//

import Foundation

public struct PlaceSearchUseCase {
    public var getSearchList: @Sendable (String) async throws -> [LocationInfo]
    public init(getSearchList: @escaping @Sendable (_ query: String) async throws -> [LocationInfo]) {
        self.getSearchList = getSearchList
    }
}

