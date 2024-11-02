//
//  DiarySchedule.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

import Foundation

public struct DiarySchedule: Decodable, Hashable {
	public let scheduleId: Int
	public let scheduleType: Int
	public let categoryInfo: DiaryScheduleCategory
	public let scheduleStartDate: Date
	public let scheduleEndDate: Date
	public let scheduleTitle: String
	public let diaryId: Int
	public let participantInfo: DiaryScheduleParticipant
	
	public init(scheduleId: Int, scheduleType: Int, categoryInfo: DiaryScheduleCategory, scheduleStartDate: Date, scheduleEndDate: Date, scheduleTitle: String, diaryId: Int, participantInfo: DiaryScheduleParticipant) {
		self.scheduleId = scheduleId
		self.scheduleType = scheduleType
		self.categoryInfo = categoryInfo
		self.scheduleStartDate = scheduleStartDate
		self.scheduleEndDate = scheduleEndDate
		self.scheduleTitle = scheduleTitle
		self.diaryId = diaryId
		self.participantInfo = participantInfo
	}
}

public struct DiaryScheduleCategory: Decodable, Hashable {
	public let name: String
	public let colorId: Int
	
	public init(name: String, colorId: Int) {
		self.name = name
		self.colorId = colorId
	}
}

public struct DiaryScheduleParticipant: Decodable, Hashable {
	public let participantsCount: Int
	public let participantsNames: String
	
	public init(participantsCount: Int, participantsNames: String) {
		self.participantsCount = participantsCount
		self.participantsNames = participantsNames
	}
}
