//
//  FriendSchedule.swift
//  DomainFriend
//
//  Created by 정현우 on 10/26/24.
//

import Foundation

import DomainSchedule

public struct FriendSchedule: Hashable {
	public let scheduleId: Int
	public let title: String
	public let categoryInfo: ScheduleCategory
	public let startDate: Date
	public let endDate: Date
	public let interval: Int
	public let scheduleType: Int
	
	public init(scheduleId: Int, title: String, categoryInfo: ScheduleCategory, startDate: Date, endDate: Date, interval: Int, scheduleType: Int) {
		self.scheduleId = scheduleId
		self.title = title
		self.categoryInfo = categoryInfo
		self.startDate = startDate
		self.endDate = endDate
		self.interval = interval
		self.scheduleType = scheduleType
	}
}
