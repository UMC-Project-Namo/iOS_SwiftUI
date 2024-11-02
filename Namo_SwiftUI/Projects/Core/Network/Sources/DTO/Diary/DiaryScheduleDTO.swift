//
//  DiaryScheduleDTO.swift
//  CoreNetwork
//
//  Created by 정현우 on 11/1/24.
//

public struct DiaryScheduleDTO: Decodable {
	public let scheduleId: Int
	public let scheduleType: Int
	public let categoryInfo: DiaryScheduleCategoryDTO
	public let scheduleStartDate: String
	public let scheduleEndDate: String
	public let scheduleTitle: String
	public let diaryId: Int
	public let participantInfo: DiaryScheduleParticipantDTO
	
	public init(scheduleId: Int, scheduleType: Int, categoryInfo: DiaryScheduleCategoryDTO, scheduleStartDate: String, scheduleEndDate: String, scheduleTitle: String, diaryId: Int, participantInfo: DiaryScheduleParticipantDTO) {
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

public struct DiaryScheduleCategoryDTO: Decodable {
	public let name: String
	public let colorId: Int
	
	public init(name: String, colorId: Int) {
		self.name = name
		self.colorId = colorId
	}
}

public struct DiaryScheduleParticipantDTO: Decodable {
	public let participantsCount: Int
	public let participantsNames: String
	
	public init(participantsCount: Int, participantsNames: String) {
		self.participantsCount = participantsCount
		self.participantsNames = participantsNames
	}
}
