//
//  NamoArchiveCalendarView.swift
//  FeatureCalendar
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI

import SwiftUICalendar

import SharedUtil
import SharedDesignSystem
import DomainDiary

public struct NamoArchiveCalendarView: View {
	@ObservedObject var calendarController: CalendarController
	// 현재 포커싱된(detailView) 날짜
	@Binding var focusDate: YearMonthDay?
	// 스케쥴 타입
	@Binding var diaryScheduleTypes: [YearMonthDay: DiaryScheduleType]
	// 캘린더에 표시할 스케쥴
	@Binding var schedules: [YearMonthDay: [DiarySchedule]]
	// 상단에 요일을 보이게 할지
	let showWeekDay: Bool
	// 하단 detail view를 보이게 할지
	let showDetailView: Bool
	// 특정 달을 선택했을때
	let dateTapAction: (YearMonthDay) -> Void
	
	private let weekdays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
	
	public init(
		calendarController: CalendarController,
		focusDate: Binding<YearMonthDay?> = .constant(nil),
		diaryScheduleTypes: Binding<[YearMonthDay: DiaryScheduleType]> = .constant([:]),
		schedules: Binding<[YearMonthDay: [DiarySchedule]]> = .constant([:]),
		showWeekDay: Bool = true,
		showDetailView: Bool = true,
		dateTapAction: @escaping (YearMonthDay) -> Void = { _ in }
	) {
		self.calendarController = calendarController
		self._focusDate = focusDate
		self._diaryScheduleTypes = diaryScheduleTypes
		self._schedules = schedules
		self.showWeekDay = showWeekDay
		self.showDetailView = showDetailView
		self.dateTapAction = dateTapAction
	}
	
	public var body: some View {
		VStack(spacing: 0) {
			if showWeekDay {
				weekday
					.padding(.bottom, 11)
			}
			
			GeometryReader { reader in
				VStack {
					CalendarView(calendarController) { date in
						GeometryReader { geometry in
							VStack(alignment: .leading) {
								ArchiveCalendarItem(
									focusDate: $focusDate,
									date: date,
									diaryScheduleType: diaryScheduleTypes[date] ?? .noSchedule
								)
								.onTapGesture {
									dateTapAction(date)
								}
							}
							.frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
						}
					}
				}
			}
			.padding(.leading, 14)
			.padding(.horizontal, 6)
			.padding(.top, 3)
			
			if showDetailView && focusDate != nil {
				detailView
			}
		}
	}
	
	private var weekday: some View {
		VStack(alignment: .leading) {
			HStack {
				ForEach(weekdays, id: \.self) { weekday in
					Text(weekday)
						.font(.pretendard(.bold, size: 12))
						.foregroundStyle(Color(asset: SharedDesignSystemAsset.Assets.textUnselected))
					
					Spacer()
				}
			}
			.padding(.leading, 14)
			.padding(.trailing, 6)
		}
		.frame(height: 30)
		.background(
			Rectangle()
				.fill(Color.white)
				.shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 8)
		)
	}
	
	private var detailView: some View {
		let focusDate = focusDate!
		
		return VStack(spacing: 0) {
			HStack {
				Spacer()
				
				Text(String(format: "%02d.%02d (%@)", focusDate.month, focusDate.day, focusDate.getShortWeekday()))
					.font(.pretendard(.bold, size: 22))
					.padding(.vertical, 20)
				
				Spacer()
			}
			.contentShape(Rectangle())
			.gesture(
				DragGesture()
					.onChanged { value in
						let dragHeight = value.translation.height
						if dragHeight > 0 {
							withAnimation {
								self.focusDate = nil
							}
						}
					}
			)
			
			ScrollView(.vertical, showsIndicators: false) {
				detailViewPersonalSchedule
					.padding(.bottom, 32)
				
				detailViewMeetingSchedule
				
				Spacer()
					.frame(height: 50)
			}
			.padding(.leading, 28)
			.padding(.trailing, 22)
		}
		.background(Color.white)
		.clipShape(RoundedCorners(radius: 15, corners: [.topLeft, .topRight]))
		.shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: -5)
		.mask {
			// 상단에만 shadow를 주기 위함
			Rectangle().padding(.top, -20)
		}
	}
	
	private var detailViewPersonalSchedule: some View {
		VStack {
			HStack {
				Text("개인 일정")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
					.padding(.bottom, 11)
					.padding(.leading, 3)
				
				Spacer()
			}
			
			// 개인 일정
			if let schedules = schedules[focusDate!]?.filter({$0.scheduleType == 0 || $0.scheduleType == 2}),
			   !schedules.isEmpty
			{
				ForEach(schedules, id: \.self) { schedule in
					ArchiveCalendarDetailScheduleItem(
						ymd: focusDate!,
						schedule: schedule
					)
				}
			} else {
				HStack(spacing: 12) {
					Rectangle()
						.fill(Color.textPlaceholder)
						.frame(width: 3, height: 21)
					
					Text("등록된 개인 일정이 없습니다.")
						.font(.pretendard(.medium, size: 14))
						.foregroundStyle(Color.textDisabled)
					
					Spacer()
				}
			}
		}
	}
	
	private var detailViewMeetingSchedule: some View {
		VStack {
			HStack {
				Text("모임 일정")
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.mainText)
					.padding(.bottom, 11)
					.padding(.leading, 3)
				
				Spacer()
			}
			
			// 개인 일정
			if let schedules = schedules[focusDate!]?.filter({$0.scheduleType == 1}),
			   !schedules.isEmpty
			{
				ForEach(schedules, id: \.self) { schedule in
					ArchiveCalendarDetailScheduleItem(
						ymd: focusDate!,
						schedule: schedule
					)
				}
			} else {
				HStack(spacing: 12) {
					Rectangle()
						.fill(Color(asset: SharedDesignSystemAsset.Assets.textPlaceholder))
						.frame(width: 3, height: 21)
					
					Text("등록된 모임 일정이 없습니다.")
						.font(.pretendard(.medium, size: 14))
						.foregroundStyle(Color.textDisabled)
					
					Spacer()
				}
			}
		}
	}
}
