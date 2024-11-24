//
//  ArchiveCalendarView.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import FeatureCalendar
import SharedUtil
import SharedDesignSystem


public struct ArchiveCalendarView: View {
	@Perception.Bindable public var store: StoreOf<ArchiveCalendarStore>
	@StateObject var calendarController = CalendarController(orientation: .vertical)
	
	public init(store: StoreOf<ArchiveCalendarStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 0) {
				NamoArchiveCalendarView(
					calendarController: calendarController,
					focusDate: $store.focusDate,
					diaryScheduleTypes: $store.diaryScheduleTypes,
					schedules: $store.schedules,
					dateTapAction: { date in
						store.send(.getScheduleDetail(ymd: date))
						store.send(.selectDate(date), animation: .default)
					}
				)
				
				Spacer()
					.frame(height: tabBarHeight)
			}
			.ignoresSafeArea(edges: .bottom)
			.onAppear {
				store.send(.getSchedules(ym: calendarController.yearMonth))
			}
			.onChange(of: calendarController.yearMonth) { newYM in
				store.send(.getSchedules(ym: calendarController.yearMonth))
			}
			.namoNabBar(
				center: {
					Text("보관함")
						.font(.pretendard(.bold, size: 16))
						.foregroundStyle(Color.colorBlack)
				},
				left: {
					Button(
						action: {
							store.send(.backBtnTapped)
						},
						label: {
							Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
						}
					)
				}
			)
		}
	}
}
