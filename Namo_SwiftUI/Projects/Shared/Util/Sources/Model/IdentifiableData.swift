//
//  IdentifiableData.swift
//  SharedUtil
//
//  Created by 박민서 on 12/11/24.
//

import Foundation

public struct IdentifiableData: Identifiable, Equatable {
    public let id: UUID
    public let data: Data
    
    public init(id: UUID = UUID(), data: Data) {
        self.id = id
        self.data = data
    }
}
