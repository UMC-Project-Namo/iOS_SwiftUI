//
//  ArchiveCalendarItem.swift
//  FeatureCalendar
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI
import SwiftUICalendar

import SharedUtil
import SharedDesignSystem
import DomainDiary

struct ArchiveCalendarItem: View {
	@Binding var focusDate: YearMonthDay?
	let date: YearMonthDay
	let schedules: [DiarySchedule]
	
	private let MAX_SCHEDULE = screenHeight < 800 ? 3 : 4
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 4) {
				dayView
				
//				calendarItem(geometry: geometry)
			}
			.padding(.top, 4)
			.padding(.leading, 5)
		}
		.contentShape(Rectangle())
	}
	
	private var dayView: some View {
		VStack(spacing: 0) {
			if date.day == 1 {
				Text("\(date.month)/\(date.day)")
					.font(.pretendard(.bold, size: 12))
					.foregroundStyle(Color.mainOrange)
			} else {
				Text("\(date.day)")
					.font(.pretendard(.bold, size: 12))
					.foregroundStyle(Color.black)
			}
		}
	}
	
}
