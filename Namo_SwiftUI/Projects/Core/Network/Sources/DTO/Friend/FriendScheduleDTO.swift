//
//  FriendScheduleDTO.swift
//  CoreNetwork
//
//  Created by 정현우 on 10/26/24.
//

public typealias GetMonthlyFriendScheduleResponseDTO = [FriendScheduleDTO]

public struct FriendScheduleDTO: Decodable {
	public let scheduleId: Int
	public let title: String
	public let categoryInfo: ScheduleCategoryDTO
	public let startDate: String
	public let endDate: String
	public let interval: Int
	public let scheduleType: Int
	
	public init(scheduleId: Int, title: String, categoryInfo: ScheduleCategoryDTO, startDate: String, endDate: String, interval: Int, scheduleType: Int) {
		self.scheduleId = scheduleId
		self.title = title
		self.categoryInfo = categoryInfo
		self.startDate = startDate
		self.endDate = endDate
		self.interval = interval
		self.scheduleType = scheduleType
	}
}
