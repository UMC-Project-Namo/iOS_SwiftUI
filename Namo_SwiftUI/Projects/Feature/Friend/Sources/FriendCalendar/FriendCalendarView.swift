//
//  FriendCalendarView.swift
//  FeatureFriend
//
//  Created by 정현우 on 10/26/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import SharedUtil
import SharedDesignSystem
import FeatureCalendar

public struct FriendCalendarView: View {
	@Perception.Bindable var store: StoreOf<FriendCalendarStore>
	@StateObject var calendarController = CalendarController()
	
	public init(store: StoreOf<FriendCalendarStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 0) {
				header
					.padding(.bottom, 22)
					.padding(.horizontal, 20)
				
				NamoFriendCalendarView(
					calendarController: calendarController,
					focusDate: $store.focusDate,
					schedules: $store.schedules,
					dateTapAction: { date in
						store.send(.selectDate(date), animation: .default)
					}
				)
				
				Spacer()
					.frame(height: tabBarHeight)
			}
			.ignoresSafeArea(edges: .bottom)
			.toolbar(.hidden, for: .navigationBar)
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
				}
			)
			.namoPopupView(
				isPresented: $store.showCategoryPopup,
				title: "캘린더 정보",
				content: {
					calendarInfo
				}
			)

		}
	}
	
	private var header: some View {
		HStack(spacing: 0) {
			// 뒤로가기
			Button(
				action: {
					store.send(.backBtnTapped)
				}, label: {
					Image(asset: SharedDesignSystemAsset.Assets.icArrowOnlyHead)
				}
			)
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
			
			Text(store.friend.nickname)
				.font(.pretendard(.bold, size: 22))
				.foregroundStyle(Color.colorBlack)
				.padding(.trailing, 3)
			
			
			Button(
				action: {
					store.send(.calendarInfoTapped)
				}, label: {
					Image(asset: SharedDesignSystemAsset.Assets.icMoire)
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
	
	private var calendarInfo: some View {
		VStack(alignment: .center, spacing: 0) {
			LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
				ForEach(store.friendCategory, id: \.self) { category in
					HStack(spacing: 16) {
						ColorCircleView(color: PalleteColor(rawValue: category.colorId)!.color)
							.frame(width: 20, height: 20)
						
						Text(category.categoryName)
							.font(.pretendard(.regular, size: 15))
							.foregroundStyle(Color.mainText)
							.lineLimit(1)
					}
				}
				
			}
			.padding(.vertical, 28)
			.padding(.horizontal, 35)
			
			Text("친구가 공개 설정을 해둔 카테고리만 볼 수 있습니다.")
				.font(.pretendard(.regular, size: 12))
				.foregroundStyle(Color.textDisabled)
				.padding(.bottom, 24)
		}
	}
	
	
}
