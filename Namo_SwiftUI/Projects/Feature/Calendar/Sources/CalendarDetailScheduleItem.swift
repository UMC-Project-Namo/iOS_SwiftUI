//
//  CalendarDetailScheduleItem.swift
//  FeatureCalendar
//
//  Created by 정현우 on 10/2/24.
//

import SwiftUI

import SwiftUICalendar

import SharedDesignSystem
import SharedUtil
import DomainSchedule

public struct CalendarDetailScheduleItem: View {
	let ymd: YearMonthDay
	let schedule: Schedule
	let diaryEditAction: () -> Void
	
	let scheduleUseCase = ScheduleUseCase.liveValue
	
	public init(
		ymd: YearMonthDay,
		schedule: Schedule,
		diaryEditAction: @escaping () -> Void
	) {
		self.ymd = ymd
		self.schedule = schedule
		self.diaryEditAction = diaryEditAction
	}
	
	public var body: some View {
		HStack(spacing: 14) {
			Rectangle()
				.fill(PalleteColor(rawValue: schedule.categoryInfo.colorId)?.color ?? .clear)
				.frame(width: 30, height: schedule.scheduleType == 1 ? 74 : 56)
				.clipShape(RoundedCorners(radius: 15, corners: [.topLeft, .bottomLeft]))
			
			VStack(alignment: .leading, spacing: 4) {
				HStack(spacing: 8) {
					Text(
						scheduleUseCase.getScheduleTimeWithBaseYMD(
							schedule: schedule,
							baseYMD: ymd
						)
					)
					.font(.pretendard(.medium, size: 12))
					.foregroundStyle(Color.mainText)
					
					Rectangle()
						.fill(Color.mainText)
						.frame(width: 1, height: 10)
					
					Text(schedule.categoryInfo.name)
						.font(.pretendard(.medium, size: 12))
						.foregroundStyle(Color.mainText)
				}
				
				Text(schedule.title)
					.font(.pretendard(.bold, size: 15))
					.foregroundStyle(Color.colorBlack)
				
				if schedule.scheduleType == 1,
				   let meetingInfo = schedule.meetingInfo
				{
					HStack {
						Text("\(meetingInfo.participantCount)")
							.font(.pretendard(.bold, size: 12))
							.foregroundStyle(Color.mainText)
						
						Text(meetingInfo.participantNicknames)
							.font(.pretendard(.medium, size: 12))
							.foregroundStyle(Color.mainText)
							.lineLimit(1)
					}
				}
				
			}
			.padding(.vertical, 10)
			
			Spacer()
			
			Button(
				action: {
					diaryEditAction()
				},
				label: {
					Image(asset: schedule.hasDiary ? SharedDesignSystemAsset.Assets.btnAddRecordOrange : SharedDesignSystemAsset.Assets.btnAddRecord)
						.resizable()
						.frame(width: 34, height: 34)
						.padding(.trailing, 11)
				}
			)
		}
		.frame(width: screenWidth-50)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.itemBackground)
				.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
		)
		.onTapGesture {
			diaryEditAction()
		}
	}
}
