//
//  ScheduleDTO.swift
//  Namo_SwiftUI
//
//  Created by 정현우 on 2/5/24.
//

import Foundation

import SharedUtil

public typealias GetMonthlyScheduleResponseDTO = [ScheduleDTO]

public struct ScheduleDTO: Decodable {
	public let scheduleId: Int
	public let title: String
	public let categoryInfo: ScheduleCategoryDTO
	public let startDate: String
	public let endDate: String
	public let interval: Int
	public let locationInfo: ScheduleLocationDTO?
	public let hasDiary: Bool
	public let scheduleType: Int
	public let meetingInfo: ScheduleMeetingDTO?
	public let notificationInfo: [ScheduleNotificationDTO]?
	
	public init(
		scheduleId: Int,
		title: String,
		categoryInfo: ScheduleCategoryDTO,
		startDate: String,
		endDate: String,
		interval: Int,
		locationInfo: ScheduleLocationDTO,
		hasDiary: Bool,
		scheduleType: Int,
		meetingInfo: ScheduleMeetingDTO?,
		notificationInfo: [ScheduleNotificationDTO]?
	) {
		self.scheduleId = scheduleId
		self.title = title
		self.categoryInfo = categoryInfo
		self.startDate = startDate
		self.endDate = endDate
		self.interval = interval
		self.locationInfo = locationInfo
		self.hasDiary = hasDiary
		self.scheduleType = scheduleType
		self.meetingInfo = meetingInfo
		self.notificationInfo = notificationInfo
	}
}

public struct ScheduleCategoryDTO: Codable {
	public let categoryId: Int
	public let colorId: Int
	public let name: String
	public let isShared: Bool
	
	public init(
		categoryId: Int,
		colorId: Int,
		name: String,
		isShared: Bool
	) {
		self.categoryId = categoryId
		self.colorId = colorId
		self.name = name
		self.isShared = isShared
	}
}

public struct ScheduleLocationDTO: Codable {
	public let longitude: Double
	public let latitude: Double
	public let locationName: String
	public let kakaoLocationId: String
	
	public init(
		longitude: Double,
		latitude: Double,
		locationName: String,
		kakaoLocationId: String
	) {
		self.longitude = longitude
		self.latitude = latitude
		self.locationName = locationName
		self.kakaoLocationId = kakaoLocationId
	}
}

public struct ScheduleMeetingDTO: Decodable {
	public let participantCount: Int
	public let participantNicknames: String
	public let isOwner: Bool
	
	public init(
		participantCount: Int,
		participantNicknames: String,
		isOwner: Bool
	) {
		self.participantCount = participantCount
		self.participantNicknames = participantNicknames
		self.isOwner = isOwner
	}
}

public struct ScheduleNotificationDTO: Decodable {
	public let notificationId: Int
	public let trigger: String
	
	public init(
		notificationId: Int,
		trigger: String
	) {
		self.notificationId = notificationId
		self.trigger = trigger
	}
}
