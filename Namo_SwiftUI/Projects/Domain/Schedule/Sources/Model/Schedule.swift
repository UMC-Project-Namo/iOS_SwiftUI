//
//  Schedule.swift
//  DomainSchedule
//
//  Created by 정현우 on 9/18/24.
//

import Foundation

public struct Schedule: Decodable, Hashable {
	public let scheduleId: Int
	public let title: String
	public let categoryInfo: ScheduleCategory
	public let startDate: Date
	public let endDate: Date
	public let interval: Int
	public let locationInfo: ScheduleLocation?
	public let hasDiary: Bool
	public let scheduleType: Int
	public let meetingInfo: ScheduleMeeting?
	public let notificationInfo: [ScheduleNotification]
	
	public init(
		scheduleId: Int,
		title: String,
		categoryInfo: ScheduleCategory,
		startDate: Date,
		endDate: Date,
		interval: Int,
		locationInfo: ScheduleLocation?,
		hasDiary: Bool,
		scheduleType: Int,
		meetingInfo: ScheduleMeeting?,
		notificationInfo: [ScheduleNotification]
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

public struct ScheduleCategory: Codable, Hashable {
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

public struct ScheduleLocation: Codable, Hashable {
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

public struct ScheduleMeeting: Decodable, Hashable {
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

public struct ScheduleNotification: Decodable, Hashable {
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

public extension Schedule {
	static let dummySchedules: [Schedule] = [
		Schedule(
			scheduleId: 1,
			title: "Test1",
			categoryInfo: ScheduleCategory(
				categoryId: 1,
				colorId: 1,
				name: "학교",
				isShared: true
			),
			startDate: Date(timeIntervalSince1970: 1727860000),
			endDate: Date(timeIntervalSince1970: 1727863275),
			interval: 1,
			locationInfo: ScheduleLocation(
				longitude: 36.0,
				latitude: 127.0,
				locationName: "위치위치",
				kakaoLocationId: ""
			),
			hasDiary: false,
			scheduleType: 0,
			meetingInfo: nil,
			notificationInfo: []
		),
		Schedule(
			scheduleId: 2,
			title: "Test2",
			categoryInfo: ScheduleCategory(
				categoryId: 1,
				colorId: 1,
				name: "학교",
				isShared: true
			),
			startDate: Date(timeIntervalSince1970: 1727800000),
			endDate: Date(timeIntervalSince1970: 1727863275),
			interval: 2,
			locationInfo: ScheduleLocation(
				longitude: 36.0,
				latitude: 127.0,
				locationName: "위치위치",
				kakaoLocationId: ""
			),
			hasDiary: false,
			scheduleType: 0,
			meetingInfo: nil,
			notificationInfo: []
		),
		Schedule(
			scheduleId: 3,
			title: "Test3",
			categoryInfo: ScheduleCategory(
				categoryId: 1,
				colorId: 1,
				name: "학교",
				isShared: true
			),
			startDate: Date(timeIntervalSince1970: 1727800000),
			endDate: Date(timeIntervalSince1970: 1727863275),
			interval: 2,
			locationInfo: ScheduleLocation(
				longitude: 36.0,
				latitude: 127.0,
				locationName: "위치위치",
				kakaoLocationId: ""
			),
			hasDiary: false,
			scheduleType: 0,
			meetingInfo: ScheduleMeeting(
				participantCount: 3,
				participantNicknames: "연현,램프,반디",
				isOwner: true
			),
			notificationInfo: []
		)
		
		
	]
}
