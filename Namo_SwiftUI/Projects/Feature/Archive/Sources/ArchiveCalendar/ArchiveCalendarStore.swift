//
//  ArchiveCalendarStore.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import DomainDiary

@Reducer
public struct ArchiveCalendarStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 달력에서 현재 focusing된 날짜
		var focusDate: YearMonthDay? = nil
		
		// 캘린더에 표시될 일정
		var schedules: [YearMonthDay: [DiarySchedule]] = [:]
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		// 뒤로가기
		case backBtnTapped
		// 특정 날짜 선택
		case selectDate(YearMonthDay)
		
	}
	
	public var body: some ReducerOf<Self> {
		BindingReducer()
		
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
				
			case .backBtnTapped:
				return .none
				
			case .selectDate(let date):
				if state.focusDate == date {
					state.focusDate = nil
				} else {
					state.focusDate = date
				}
				
				return .none
			}
		}
	}
	
}
