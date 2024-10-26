//
//  Location.swift
//  DomainPlaceSearch
//
//  Created by 권석기 on 10/21/24.
//

import Foundation

public struct LocationInfo: Equatable {
    public init(id: String,
                placeName: String,
                x: String,
                y: String,
                addressName: String,
                roadAddressName: String) {
        self.id = id
        self.placeName = placeName
        self.x = x
        self.y = y
        self.addressName = addressName
        self.roadAddressName = roadAddressName
    }
    
    public let id: String
    public let placeName: String
    public let x: String
    public let y: String
    public let addressName: String
    public let roadAddressName: String
}


