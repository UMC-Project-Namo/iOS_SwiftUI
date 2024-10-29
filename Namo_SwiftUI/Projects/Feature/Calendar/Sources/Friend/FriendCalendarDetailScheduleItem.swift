//
//  FriendCalendarDetailScheduleItem.swift
//  FeatureCalendar
//
//  Created by 정현우 on 10/26/24.
//

import SwiftUI

import SwiftUICalendar

import SharedDesignSystem
import SharedUtil
import DomainFriend

public struct FriendCalendarDetailScheduleItem: View {
	let ymd: YearMonthDay
	let schedule: FriendSchedule
	
	let friendUseCase = FriendUseCase.liveValue
	
	public init(
		ymd: YearMonthDay,
		schedule: FriendSchedule
	) {
		self.ymd = ymd
		self.schedule = schedule
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
						friendUseCase.getScheduleTimeWithBaseYMD(
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
				
			}
			.padding(.vertical, 10)
			
			Spacer()
		}
		.frame(width: screenWidth-50)
		.background(
			RoundedRectangle(cornerRadius: 15)
				.fill(Color.itemBackground)
				.shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 0)
		)
	}
}
