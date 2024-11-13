//
//  DiaryMapper.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

import Foundation

import CoreNetwork
import SharedUtil

// MARK: - toEntity()
extension DiaryCalendarDTO {
	func toEntity() -> DiaryCalendar {
		return DiaryCalendar(
			year: year,
			month: month,
			diaryDateForPersonal: diaryDateForPersonal,
			diaryDateForMeeting: diaryDateForMeeting,
			diaryDateForBirthday: diaryDateForBirthday
		)
	}
}

extension DiaryScheduleDTO {
	func toEntity() -> DiarySchedule {
		return DiarySchedule(
			scheduleId: scheduleId,
			scheduleType: scheduleType,
			categoryInfo: categoryInfo.toEntity(),
			scheduleStartDate: Date.ISO8601toDate(scheduleStartDate),
			scheduleEndDate: Date.ISO8601toDate(scheduleEndDate),
			scheduleTitle: scheduleTitle,
			diaryId: diaryId,
			participantInfo: participantInfo.toEntity()
		)
	}
}

extension DiaryScheduleCategoryDTO {
	func toEntity() -> DiaryScheduleCategory {
		return DiaryScheduleCategory(
			name: name,
			colorId: colorId
		)
	}
}

extension DiaryScheduleParticipantDTO {
	func toEntity() -> DiaryScheduleParticipant {
		return DiaryScheduleParticipant(
			participantsCount: participantsCount,
			participantsNames: participantsNames
		)
	}
}
