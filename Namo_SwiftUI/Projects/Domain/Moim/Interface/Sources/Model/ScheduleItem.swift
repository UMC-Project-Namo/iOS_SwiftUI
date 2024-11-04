//
//  ScheduleItem.swift
//  DomainMoimInterface
//
//  Created by 권석기 on 10/3/24.
//

import Foundation

public struct MoimScheduleItem: Decodable, Hashable, Identifiable {
    public init(meetingScheduleId: Int,
                title: String,
                startDate: String,
                imageUrl: String,
                participantCount: Int,
                participantNicknames: String) {
        self.meetingScheduleId = meetingScheduleId
        self.title = title
        self.startDate = startDate
        self.imageUrl = imageUrl
        self.participantCount = participantCount
        self.participantNicknames = participantNicknames
    }
    public var id: Int { meetingScheduleId }
    public let meetingScheduleId: Int
    public let title: String
    public let startDate: String
    public let imageUrl: String
    public let participantCount: Int
    public let participantNicknames: String
}
