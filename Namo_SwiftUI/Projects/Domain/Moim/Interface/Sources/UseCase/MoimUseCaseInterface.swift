//
//  MoimUseCaseInterface.swift
//  DomainMoim
//
//  Created by 권석기 on 10/2/24.
//

import UIKit
import ComposableArchitecture

/// 모임 관련 유스케이스 인터페이스
public struct MoimUseCase {
    public var getMoimList: @Sendable () async throws -> [MoimScheduleItem]
    public var createMoim: @Sendable (MoimSchedule, UIImage?) async throws -> Void
    
    public init(getMoimList: @escaping @Sendable () async throws -> [MoimScheduleItem],
                createMoim: @escaping @Sendable (MoimSchedule, UIImage?) async throws -> Void) {
        self.getMoimList = getMoimList
        self.createMoim = createMoim        
    }
}