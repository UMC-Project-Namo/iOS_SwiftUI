//
//  PlaceMapper.swift
//  DomainPlaceSearch
//
//  Created by 권석기 on 10/21/24.
//

import Foundation
import CoreNetwork

public extension KakaoLocationSearchDocument {
    func toEntity() -> LocationInfo {
        .init(id: id,
              placeName: placeName,
              x: x,
              y: y,
              addressName: addressName,
              roadAddressName: roadAddressName)
    }
}
