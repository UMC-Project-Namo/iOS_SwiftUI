//
//  DiaryUseCase.swift
//  DomainDiary
//
//  Created by 정현우 on 11/1/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import CoreNetwork

@DependencyClient
public struct DiaryUseCase {
	// 캘린더 일정 +-1 달씩 월별로 가져오기
	public func getCalendarByMonth(ym: YearMonth) async throws -> [YearMonthDay: DiaryScheduleType] {
		var result: [YearMonthDay: DiaryScheduleType] = [:]
		
		for i in -1...1 {
			let currentYM = ym.addMonth(i)
			let response: BaseResponse<DiaryCalendar> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.getCalendarByMonth(ym: currentYM))
			
			response.result?.diaryDateForPersonal.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .personalOrBirthdaySchedule
			}
			
			response.result?.diaryDateForBirthday.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .personalOrBirthdaySchedule
			}
			
			response.result?.diaryDateForMeeting.forEach { day in
				result[YearMonthDay(year: currentYM.year, month: currentYM.month, day: day), default: .noSchedule] = .meetingSchedule
			}
			
		}
		
		return result
	}
	
	// 특정 일 스케쥴 가져오기
	public func getDiaryByDate(ymd: YearMonthDay) async throws -> [DiarySchedule] {
		let response: BaseResponse<[DiarySchedule]> = try await APIManager.shared.performRequest(endPoint: DiaryEndPoint.getDiaryByDate(ymd: ymd))
		
		return response.result ?? []
	}
	
	// detailView의 Schedule에 표시할 시간을 리턴하는 함수
	// 하루 일정인지 여러 일 지속 일정인지에 따라 리턴 다르게
	public func getScheduleTimeWithBaseYMD(
		schedule: DiarySchedule,
		baseYMD: YearMonthDay
	) -> String {
		if schedule.scheduleStartDate.toYMD() == schedule.scheduleEndDate.adjustDateIfMidNight().toYMD() {
			// 같은 날이라면 그냥 시작시간-종료시간 표시
			return "\(schedule.scheduleStartDate.toHHmm()) - \(schedule.scheduleEndDate.adjustDateIfMidNight().toHHmm())"
		} else if baseYMD == schedule.scheduleStartDate.toYMD() {
			// 여러 일 지속 스케쥴의 시작일이라면
			return "\(schedule.scheduleStartDate.toHHmm()) - 23:59"
		} else if baseYMD == schedule.scheduleEndDate.toYMD() {
			// 여러 일 지속 스케쥴의 종료일이라면
			return "00:00 - \(schedule.scheduleEndDate.adjustDateIfMidNight().toHHmm())"
		} else {
			// 여러 일 지속 스케쥴의 중간이라면
			return "00:00 - 23:59"
		}
	}
}

extension DiaryUseCase: DependencyKey {
	public static var liveValue: DiaryUseCase {
		return DiaryUseCase()
	}
}

extension DependencyValues {
	public var diaryUseCase: DiaryUseCase {
		get { self[DiaryUseCase.self] }
		set { self[DiaryUseCase.self] = newValue }
	}
}
