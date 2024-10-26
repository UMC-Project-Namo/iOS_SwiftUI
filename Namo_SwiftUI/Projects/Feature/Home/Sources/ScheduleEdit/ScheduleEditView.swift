//
//  ScheduleEditView.swift
//  FeatureHome
//
//  Created by 정현우 on 10/3/24.
//

import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

struct ScheduleEditView: View {
	@Perception.Bindable var store: StoreOf<ScheduleEditStore>
	
	var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 0) {
				navigationBar
					.padding(.horizontal, 19)
				
				ScrollView {
					VStack {
						title
						
						listItems
						
						Spacer()
					}
				}
				.padding(.horizontal, 30)
			}
			.background(Color.white)
		}
		.toolbar(.hidden, for: .navigationBar)
	}
	
	private var navigationBar: some View {
		ScheduleEditNavigationBar(
			title: store.isNewSchedule ? "일정 생성" : "일정 편집",
			leftButton: {
				Button(
					action: {
						store.send(.closeBtnTapped)
					},
					label: {
						Text("취소")
							.font(.pretendard(.regular, size: 15))
					}
				)
				.tint(Color.mainText)
			},
			rightButton: {
				Button(
					action: {
						store.send(.saveBtnTapped)
					},
					label: {
						Text(store.isNewSchedule ? "생성" : "저장")
							.font(.pretendard(.regular, size: 15))
					}
				)
				.tint(Color.mainText)
			}
		)
	}

	
	private var title: some View {
		TextField("내 일정", text: $store.schedule.title)
			.font(.pretendard(.bold, size: 22))
			.padding(.top, 12)
			.padding(.bottom, 30)
			.foregroundStyle(Color(asset: SharedDesignSystemAsset.Assets.mainText))
	}
	
	private var listItems: some View {
		VStack(alignment: .center, spacing: 20) {
			listItem(
				title: "카테고리",
				content: {
					Button(
						action: {
							store.send(.selectCategoryTapped)
						},
						label: {
							if store.schedule.category.categoryId != -1 {
								HStack {
									ColorCircleView(
										color: PalleteColor(rawValue: store.schedule.category.colorId)?.color ?? .clear
									)
									.frame(width: 12, height: 12)
									
									Text(store.schedule.category.name)
										.font(.pretendard(.regular, size: 15))
								}
							} else {
								Text("없음")
									.foregroundStyle(Color.mainText)
									.font(.pretendard(.regular, size: 15))
							}
							
							Image(asset: SharedDesignSystemAsset.Assets.icRight)
						}
					)
					.tint(Color.mainText)
				}
			)
			
			listItem(
				title: "시작",
				content: {
					Button(
						action: {
							store.send(.startDatePickerToggle, animation: .default)
						},
						label: {
							Text(store.schedule.period.startDate.toYMDEHMa())
								.foregroundStyle(Color.mainText)
								.font(.pretendard(.regular, size: 15))
						}
					)
				}
			)
			
			if store.showStartDatePicker {
				DatePicker(
					"",
					selection: $store.schedule.period.startDate
				)
				.datePickerStyle(.graphical)
				.tint(Color.mainOrange)
			}
			
			listItem(
				title: "종료",
				content: {
					Button(
						action: {
							store.send(.endDatePickerToggle, animation: .default)
						},
						label: {
							Text(store.schedule.period.endDate.toYMDEHMa())
								.foregroundStyle(Color.mainText)
								.font(.pretendard(.regular, size: 15))
						}
					)
				}
			)
			
			if store.showEndDatePicker {
				DatePicker(
					"",
					selection: $store.schedule.period.endDate
				)
				.datePickerStyle(.graphical)
				.tint(Color.mainOrange)
			}
			
			listItem(
				title: "알림",
				content: {
					Button(
						action: {
							store.send(.reminderBtnTapped)
						},
						label: {
							HStack {
								if let reminders = store.schedule.reminderTrigger,
								   !reminders.isEmpty {
									Text(reminders.joined(separator: ", "))
										.foregroundStyle(Color.mainText)
										.font(.pretendard(.regular, size: 15))
								} else {
									Text("없음")
										.foregroundStyle(Color.mainText)
										.font(.pretendard(.regular, size: 15))
								}
							}
							
							Image(asset: SharedDesignSystemAsset.Assets.icRight)
						}
					)
				}
			)
			
			listItem(
				title: "장소",
				content: {
					Button(
						action: {
							store.send(.locationBtnTapped)
						},
						label: {
							HStack {
								if let location = store.schedule.location {
									Text(location.locationName)
										.foregroundStyle(Color.mainText)
										.font(.pretendard(.regular, size: 15))
								} else {
									Text("없음")
										.foregroundStyle(Color.mainText)
										.font(.pretendard(.regular, size: 15))
								}
								
								Image(asset: SharedDesignSystemAsset.Assets.icRight)
							}
						}
					)
				}
			)
		}
	}
	
	private func listItem<Content: View>(
		title: String,
		content: () -> Content
	) -> some View {
		HStack {
			Text(title)
				.font(.pretendard(.bold, size: 15))
				.foregroundStyle(Color.mainText)
			
			Spacer()
			
			content()
		}
	}
}
