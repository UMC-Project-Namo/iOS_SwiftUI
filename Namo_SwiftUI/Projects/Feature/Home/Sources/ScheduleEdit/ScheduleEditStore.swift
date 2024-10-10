//
//  ScheduleEditStore.swift
//  FeatureHome
//
//  Created by 정현우 on 10/3/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import DomainSchedule
import DomainCategory
import SharedUtil

@Reducer
public struct ScheduleEditStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 스케쥴 생성인지 수정인지
		var isNewSchedule: Bool = false
		// 현재 생성/수정 중인 스케쥴
		@Shared var schedule: ScheduleEdit
		// 카테고리 리스트
		@Shared(.inMemory(SharedKeys.categories.rawValue)) var categories: [NamoCategory] = []
		// 시작일 캘린더
		var showStartDatePicker: Bool = false
		// 종료일 캘린더
		var showEndDatePicker: Bool = false
		
		
		public init(
			isNewSchedule: Bool,
			schedule: Shared<ScheduleEdit>
		) {
			self.isNewSchedule = isNewSchedule
			self._schedule = schedule
			
			// 신규 일정인 경우 base category 설정
			if isNewSchedule,
			   let category = self.categories.filter({$0.baseCategory}).first {
				self.schedule.category = ScheduleCategory(
					categoryId: category.categoryId,
					colorId: category.colorId,
					name: category.categoryName,
					isShared: category.shared
				)
			}
		}
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		// 닫기 버튼
		case closeBtnTapped
		// 저장 버튼
		case saveBtnTapped
		// 카테고리 선택
		case selectCategoryTapped
		// 시작 캘린더 토글
		case startDatePickerToggle
		// 종료 캘린더 토글
		case endDatePickerToggle
		// 알림 버튼
		case reminderBtnTapped
		// 장소 버튼
		case locationBtnTapped
		
	}
	
	@Dependency(\.categoryUseCase) var categoryUseCase
	
	public var body: some ReducerOf<Self> {
		BindingReducer()
		
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
				
			case .closeBtnTapped:
				return .none
				
			case .saveBtnTapped:
				return .none
				
			case .selectCategoryTapped:
				return .none
				
			case .startDatePickerToggle:
				state.showStartDatePicker.toggle()
				
				return .none
				
			case .endDatePickerToggle:
				state.showEndDatePicker.toggle()
				
				return .none
				
			case .reminderBtnTapped:
				return .none
				
			case .locationBtnTapped:
				return .none
				
			}
		}
		
	}
	
}