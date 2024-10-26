//
//  PlaceSearchUseCase.swift
//  DomainPlaceSearch
//
//  Created by 권석기 on 10/20/24.
//

import Foundation
import ComposableArchitecture
import DomainPlaceSearchInterface
import CoreNetwork

extension PlaceSearchUseCase: DependencyKey {
    public static var liveValue: PlaceSearchUseCase = PlaceSearchUseCase { query in
        do {
            let response: KakaoLocationSearchResponseDTO = try await  APIManager.shared.performRequestWithoutBaseResponse(endPoint: KakaoEndPoint.getKakaoMapAPIRequest(req: .init(query: query)))
            
            return response.documents.map { $0.toEntity() }
        } catch {
            throw error
        }
    }
}

extension DependencyValues {
    public var placeUseCase: PlaceSearchUseCase {
        get { self[PlaceSearchUseCase.self] }
        set { self[PlaceSearchUseCase.self] = newValue }
    }
}
