//
//  FriendCalendarItem.swift
//  FeatureCalendar
//
//  Created by 정현우 on 10/26/24.
//

import SwiftUI
import SwiftUICalendar

import SharedUtil
import SharedDesignSystem
import DomainSchedule
import DomainFriend

struct FriendCalendarItem: View {
	@Binding var focusDate: YearMonthDay?
	let date: YearMonthDay
	let schedules: [CalendarFriendSchedule]
	
	private let MAX_SCHEDULE = screenHeight < 800 ? 3 : 4
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 4) {
				dayView
				
				calendarItem(geometry: geometry)
			}
			.padding(.top, 4)
			.padding(.leading, 5)
		}
		.contentShape(Rectangle())
	}
	
	private var dayView: some View {
		VStack(spacing: 0) {
			if date.isToday {
				Text("\(date.day)")
					.font(.pretendard(.bold, size: 12))
					.foregroundStyle(Color.white)
					.background(
						Circle()
							.fill(
								(date.isFocusYearMonth ?? false)
								? Color(asset: SharedDesignSystemAsset.Assets.mainOrange)
								: Color(asset: SharedDesignSystemAsset.Assets.mainOrange).opacity(0.5)
							)
							.frame(width: 18, height: 18)
					)
			} else {
				Text("\(date.day)")
					.font(.pretendard(.bold, size: 12))
					.foregroundStyle(
						focusDate == date ? Color(asset: SharedDesignSystemAsset.Assets.mainOrange) :
						(date.isFocusYearMonth ?? true) ? Color.black : Color(asset: SharedDesignSystemAsset.Assets.textUnselected)
					)
			}
		}
	}
	
	private func calendarItem(geometry: GeometryProxy) -> some View {
		let schedules = schedules.filter({
		   if focusDate == nil {
			   return $0.position >= 0 && $0.position < MAX_SCHEDULE
		   } else {
			   // 탭바 높이때문에 1개 덜 보이도록
			   return $0.position >= 0 && $0.position < MAX_SCHEDULE-1
		   }
		})
		
		return VStack(alignment: .leading, spacing: focusDate == nil ? 4 : 2) {
			ForEach(schedules.indices, id: \.self) { index in
				if let schedule = schedules[index].schedule {
					// 캘린더 펼친 상태
					if focusDate == nil {
						// 현재 날이 시작일이라면
						if date == schedule.startDate.toYMD() {
							// 현재 날이 시작일인 동시에 마지막 날이라면 -> 하루 짜리 스케쥴
							if date == schedule.endDate.adjustDateIfMidNight().toYMD() {
								CalendarScheduleItem(
									calendarScheduleItemype: .onlyOneDay,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: schedule.title
								)
							} else {
								// 여러 일 지속 스케쥴의 시작부분인데 토요일(주의 마지막)인 경우 오른쪽 코너 주기
								if date.dayOfWeek == .sat {
									CalendarScheduleItem(
										calendarScheduleItemype: .startDayWithRightCorner,
										isLargeItem: true,
										backgroundColorId: schedule.categoryInfo.colorId,
										geometryWidth: geometry.size.width,
										isFocusYearMonth: date.isFocusYearMonth ?? true,
										scheduleName: schedule.title
									)
								} else {
									// 여러일 지속 스케쥴의 시작부분
									CalendarScheduleItem(
										calendarScheduleItemype: .startDay,
										isLargeItem: true,
										backgroundColorId: schedule.categoryInfo.colorId,
										geometryWidth: geometry.size.width,
										isFocusYearMonth: date.isFocusYearMonth ?? true,
										scheduleName: schedule.title
									)
								}
							}
						} else if date == schedule.endDate.adjustDateIfMidNight().toYMD() {
							// 여러 일 지속 스케쥴 -> 끝 부분(오른쪽만 radius)
							if date.dayOfWeek == .sun {
								CalendarScheduleItem(
									calendarScheduleItemype: .endDayWithLeftCorner,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: schedule.title
								)
							} else {
								CalendarScheduleItem(
									calendarScheduleItemype: .endDay,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							}
							
						} else {
							// 여러 일 지속 스케쥴 -> 중간 부분(no radius)
							if date.dayOfWeek == .sat {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDayWithRightCorner,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							} else if date.dayOfWeek == .sun {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDayWithLeftCorner,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: schedule.title
								)
							} else {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDay,
									isLargeItem: true,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							}
						}
					} else {
						// 스케쥴 자세히 보기 상태
						if date == schedule.startDate.toYMD() {
							if date == schedule.endDate.adjustDateIfMidNight().toYMD() {
								// 만약 하루짜리 스케쥴이면 -> 한개짜리 스케쥴 item
								CalendarScheduleItem(
									calendarScheduleItemype: .onlyOneDay,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							} else {
								// 여러 일 지속 스케쥴 -> 시작 부분(왼쪽만 radius)
								if date.dayOfWeek == .sat {
									CalendarScheduleItem(
										calendarScheduleItemype: .startDayWithRightCorner,
										isLargeItem: false,
										backgroundColorId: schedule.categoryInfo.colorId,
										geometryWidth: geometry.size.width,
										isFocusYearMonth: date.isFocusYearMonth ?? true,
										scheduleName: nil
									)
								} else {
									CalendarScheduleItem(
										calendarScheduleItemype: .startDay,
										isLargeItem: false,
										backgroundColorId: schedule.categoryInfo.colorId,
										geometryWidth: geometry.size.width,
										isFocusYearMonth: date.isFocusYearMonth ?? true,
										scheduleName: nil
									)
								}
							}
						} else if date == schedule.endDate.adjustDateIfMidNight().toYMD() {
							// 여러 일 지속 스케쥴 -> 끝 부분(오른쪽만 radius)
							if date.dayOfWeek == .sun {
								CalendarScheduleItem(
									calendarScheduleItemype: .endDayWithLeftCorner,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							} else {
								CalendarScheduleItem(
									calendarScheduleItemype: .endDay,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							}
						} else {
							// 여러 일 지속 스케쥴 -> 중간 부분(no radius)
							if date.dayOfWeek == .sat {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDayWithRightCorner,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							} else if date.dayOfWeek == .sun {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDayWithLeftCorner,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							} else {
								CalendarScheduleItem(
									calendarScheduleItemype: .midDay,
									isLargeItem: false,
									backgroundColorId: schedule.categoryInfo.colorId,
									geometryWidth: geometry.size.width,
									isFocusYearMonth: date.isFocusYearMonth ?? true,
									scheduleName: nil
								)
							}
						}
					}
				} else {
					// schedule이 nil인 경우 빈 공간
					RoundedRectangle(cornerRadius: 3)
						.fill(Color.clear)
						.frame(height: focusDate == nil ? 12 : 4)
				}
			}
		}
	}
}
