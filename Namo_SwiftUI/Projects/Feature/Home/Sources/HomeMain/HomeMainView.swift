//
//  HomeMainView.swift
//  FeatureHome
//
//  Created by 정현우 on 9/18/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import SharedUtil
import SharedDesignSystem
import FeatureCalendar

public struct HomeMainView: View {
	@Perception.Bindable public var store: StoreOf<HomeMainStore>
	@StateObject var calendarController = CalendarController()
	
	public init(store: StoreOf<HomeMainStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 0) {
				header
					.padding(.bottom, 22)
					.padding(.horizontal, 20)
				
				
				NamoCalendarView(
					calendarController: calendarController,
					focusDate: $store.focusDate,
					schedules: $store.schedules,
					dateTapAction: { date in
						store.send(.selectDate(date), animation: .default)
					},
					scheduleAddTapAction: { date in
						store.send(.editSchedule(isNewSchedule: true, selectDate: date))
					},
					scheduleEditTapAction: { schedule in
						store.send(.editSchedule(isNewSchedule: false, schedule: schedule, selectDate: YearMonthDay.current))
					}
				)
				
				Spacer()
					.frame(height: tabBarHeight)
				
			}
		}
		.ignoresSafeArea(edges: .bottom)
		.onAppear {
			store.send(.getSchedule(ym: calendarController.yearMonth))
		}
		.onChange(of: calendarController.yearMonth) { newYM in
			if calendarController.yearMonth < newYM {
				// 다음달로
				store.send(.scrollForwardTo(ym: newYM))
			} else {
				// 이전달로
				store.send(.scrollBackwardTo(ym: newYM))
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .reloadCalendarViaNetwork)) { _ in
			store.send(.getSchedule(ym: calendarController.yearMonth))
		}
		.namoUnderButtonPopupView(
			isPresented: $store.showDatePicker,
			contentView: {
				datePicker
			},
			confirmAction: {
				store.showDatePicker = false
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
					calendarController.scrollTo(
						YearMonth(year: store.pickerCurrentYear, month: store.pickerCurrentMonth),
						isAnimate: true
					)
				}
				
				
				// TODO: 해당 월 일정 불러오기
				
			}
		)
	}
	
	private var header: some View {
		HStack {
			// datepicker
			Button(
				action: {
					store.send(.datePickerTapped)
				}, label: {
					HStack(spacing: 10) {
						Text(calendarController.yearMonth.formatYYYYMM())
							.font(.pretendard(.bold, size: 22))
							.foregroundStyle(Color.colorBlack)
					}
				}
			)
			
			Spacer()
			
			// 보관함
			Button(
				action: {
					store.send(.archiveTapped)
				}, label: {
					Image(asset: SharedDesignSystemAsset.Assets.icArchive)
						.resizable()
						.frame(width: 24, height: 24)
				}
			)
			.padding(.trailing, 20)
			
			// 오늘 날짜로
			Button(
				action: {
					if !store.isScrolling {
						store.isScrolling = true
						calendarController.scrollTo(.current, isAnimate: true)
						DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
							store.isScrolling = false
						}
					}
				}, label: {
					Text(Date().toDD())
						.font(.pretendard(.semibold, size: 16))
						.background(
							RoundedRectangle(cornerRadius: 5)
								.stroke(.black, lineWidth: 1.5)
								.frame(width: 25, height: 25)
						)
				}
			)
			.tint(Color.colorBlack)
			
		}
	}
	
	private var datePicker: some View {
		HStack(spacing: 0) {
			Picker("", selection: $store.pickerCurrentYear) {
				ForEach(2000...2099, id: \.self) {
					Text("\(String($0))년")
						.font(.pretendard(.regular, size: 23))
				}
			}
			.pickerStyle(.inline)
			
			Picker("", selection: $store.pickerCurrentMonth) {
				ForEach(1...12, id: \.self) {
					Text("\(String($0))월")
						.font(.pretendard(.regular, size: 23))
				}
			}
			.pickerStyle(.inline)
		}
		.frame(height: 154)
		.onAppear {
			store.pickerCurrentYear = calendarController.yearMonth.year
			store.pickerCurrentMonth = calendarController.yearMonth.month
		}
	}
}
