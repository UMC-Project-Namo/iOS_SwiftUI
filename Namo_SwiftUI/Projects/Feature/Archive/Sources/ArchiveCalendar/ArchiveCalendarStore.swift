//
//  ArchiveCalendarStore.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import CoreLocation
import DomainDiary

@Reducer
public struct ArchiveCalendarStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 달력에서 현재 focusing된 날짜
		var focusDate: YearMonthDay? = nil
		
		// 캘린더 타입
		var diaryScheduleTypes: [YearMonthDay: DiaryScheduleType] = [:]
		// 캘린더에 표시될 일정
		var schedules: [YearMonthDay: [DiarySchedule]] = [:]
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		// 뒤로가기
		case backBtnTapped
		// 특정 날짜 선택
		case selectDate(YearMonthDay)
		
		// +- 2달 일정 가져오기
		case getSchedules(ym: YearMonth)
		case getSchedulesCompleted([YearMonthDay: DiaryScheduleType])
		// 특정 날짜 일정 상세 가져오기
		case getScheduleDetail(ymd: YearMonthDay)
		case getScheduleDetailCompleted(ymd: YearMonthDay, schedules: [DiarySchedule])
		
	}
	
	@Dependency(\.diaryUseCase) var diaryUseCase
	
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
				
			case .getSchedules(let ym):
				return .run { send in
					do {
						let response = try await diaryUseCase.getCalendarByMonth(ym: ym)
						await send(.getSchedulesCompleted(response))
					} catch(let error) {
						print(error.localizedDescription)
					}
				}
				
			case .getSchedulesCompleted(let response):
				state.diaryScheduleTypes = response
				return .none
				
			case .getScheduleDetail(let ymd):
				// 이미 받아온 스케쥴들이 있다면 리턴
				if !state.schedules[ymd, default: []].isEmpty {
					return .none
				}
				
				return .run { send in
					do {
						let response = try await diaryUseCase.getDiaryByDate(ymd: ymd)
						await send(.getScheduleDetailCompleted(ymd: ymd, schedules: response))
					} catch(let error) {
						print(error.localizedDescription)
					}
				}
				
			case .getScheduleDetailCompleted(let ymd, let response):
				state.schedules[ymd, default: []] = response
				return .none
			}
		}
	}
	
}
