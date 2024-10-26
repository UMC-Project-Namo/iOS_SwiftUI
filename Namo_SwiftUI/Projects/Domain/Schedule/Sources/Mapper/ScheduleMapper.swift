//
//  ScheduleMapper.swift
//  DomainSchedule
//
//  Created by 정현우 on 9/18/24.
//

import Foundation

import CoreNetwork

// MARK: - toEntity()
extension ScheduleDTO {
	func toEntity() -> Schedule {
		return Schedule(
			scheduleId: scheduleId,
			title: title,
			categoryInfo: categoryInfo.toEntity(),
			startDate: Date.ISO8601toDate(startDate),
			endDate: Date.ISO8601toDate(endDate),
			interval: interval,
			locationInfo: locationInfo?.toEntity(),
			hasDiary: hasDiary,
			scheduleType: scheduleType,
			meetingInfo: meetingInfo?.toEntity(),
			notificationInfo: notificationInfo?.map { $0.toEntity() } ?? []
		)
	}
}

extension ScheduleCategoryDTO {
	func toEntity() -> ScheduleCategory {
		return ScheduleCategory(
			categoryId: categoryId,
			colorId: colorId,
			name: name,
			isShared: isShared
		)
	}
}

extension ScheduleLocationDTO {
	func toEntity() -> ScheduleLocation {
		return ScheduleLocation(
			longitude: longitude,
			latitude: latitude,
			locationName: locationName,
			kakaoLocationId: kakaoLocationId
		)
	}
}

extension ScheduleMeetingDTO {
	func toEntity() -> ScheduleMeeting {
		return ScheduleMeeting(
			participantCount: participantCount,
			participantNicknames: participantNicknames,
			isOwner: isOwner
		)
	}
}

extension ScheduleNotificationDTO {
	func toEntity() -> ScheduleNotification {
		return ScheduleNotification(
			notificationId: notificationId,
			trigger: trigger
		)
	}
}

// MARK: - toData()

extension ScheduleEdit {
	func toData() -> ScheduleEditDTO {
		return ScheduleEditDTO(
			title: title,
			categoryId: category.categoryId,
			period: period.toData(),
			location: location?.toData(),
			reminderTrigger: reminderTrigger
		)
	}
}

extension SchedulePeriod {
	func toData() -> SchedulePeriodDTO {
		return SchedulePeriodDTO(
			startDate: startDate.dateToISO8601(),
			endDate: endDate.dateToISO8601()
		)
	}
}

extension ScheduleCategory {
	func toData() -> ScheduleCategoryDTO {
		return ScheduleCategoryDTO(
			categoryId: categoryId,
			colorId: colorId,
			name: name,
			isShared: isShared
		)
	}
}

extension ScheduleLocation {
	func toData() -> ScheduleLocationDTO {
		return ScheduleLocationDTO(
			longitude: longitude,
			latitude: latitude,
			locationName: locationName,
			kakaoLocationId: kakaoLocationId
		)
	}
}

extension ScheduleMeeting {
	func toData() -> ScheduleMeetingDTO {
		return ScheduleMeetingDTO(
			participantCount: participantCount,
			participantNicknames: participantNicknames,
			isOwner: isOwner
		)
	}
}

extension ScheduleNotification {
	func toData() -> ScheduleNotificationDTO {
		return ScheduleNotificationDTO(
			notificationId: notificationId,
			trigger: trigger
		)
	}
}
