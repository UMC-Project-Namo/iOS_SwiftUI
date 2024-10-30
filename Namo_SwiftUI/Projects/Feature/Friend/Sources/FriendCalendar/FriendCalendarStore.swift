//
//  FriendCalendarStore.swift
//  FeatureFriend
//
//  Created by 정현우 on 10/26/24.
//

import SwiftUI

import ComposableArchitecture
import SwiftUICalendar

import DomainFriend

@Reducer
public struct FriendCalendarStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 현재 친구
		var friend: Friend
		// datepicker popup
		var showDatePicker: Bool = false
		
		// 달력에서 현재 focusing된 날짜
		var focusDate: YearMonthDay? = nil
		
		// 캘린더에 표시될 일정
		var schedules: [YearMonthDay: [CalendarFriendSchedule]] = [:]
		
		// datepicker selection
		var pickerCurrentYear: Int = YearMonth.current.year
		var pickerCurrentMonth: Int = YearMonth.current.month
		
		// 캘린더 debounce 대기시간동안 다시 스크롤 방지
		var isScrolling: Bool = false
		
		// 친구 카테고리 보기 팝업
		var showCategoryPopup: Bool = false
		// 친구 카테고리
		var friendCategory: [FriendCategory] = []
		
		public init(friend: Friend) {
			self.friend = friend
		}
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		case backBtnTapped
		// +- 2달 일정 가져오기
		case getSchedule(ym: YearMonth)
		// 뒤로 스크롤
		case scrollBackwardTo(ym: YearMonth)
		// 앞으로 스크롤
		case scrollForwardTo(ym: YearMonth)
		// state에 적용
		case setScheduleToState(schedules: [YearMonthDay: [CalendarFriendSchedule]])
		// datepicker popup
		case datePickerTapped
		// calendarInfo popup
		case calendarInfoTapped
		// 카테고리 가져온 응답
		case getFriendCategoryComplete(friendCategories: [FriendCategory])
		// 특정 날짜 선택
		case selectDate(YearMonthDay)
	}
	
	@Dependency(\.friendUseCase) var friendUseCase
	
	public var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
				
			case .backBtnTapped:
				return .none
			case .getSchedule(let ym):
				return .run {[friendId = state.friend.memberId] send in
					let response = await getSchedule(friendId: friendId, ym: ym)
					await send(.setScheduleToState(schedules: response))
				}
				
			case .scrollBackwardTo(let ym):
				return .run {[friendId = state.friend.memberId] send in
					let response = await getSchedule(friendId: friendId, ym: ym)
					await send(.setScheduleToState(schedules: response))
				}
			case .scrollForwardTo(let ym):
				return .run {[friendId = state.friend.memberId] send in
					let response = await getSchedule(friendId: friendId, ym: ym)
					await send(.setScheduleToState(schedules: response))
				}
				
			case .setScheduleToState(let schedules):
				state.schedules = schedules
				
				return .none
				
			case .datePickerTapped:
				state.showDatePicker = true
				
				return .none
				
			case .calendarInfoTapped:
				state.showCategoryPopup = true
				return .run {[friendId = state.friend.memberId] send in
					do {
						let response = try await friendUseCase.getFriendCategories(friendId: friendId)
						await send(.getFriendCategoryComplete(friendCategories: response))
					} catch(let error) {
						print(error.localizedDescription)
					}
				}
				
			case .getFriendCategoryComplete(let categories):
				state.friendCategory = categories
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
	
	func getSchedule(friendId: Int, ym: YearMonth) async -> [YearMonthDay: [CalendarFriendSchedule]] {
		let response = await friendUseCase.getFriendSchedule(
			friendId: friendId,
			startDate: ym.addMonth(-2).getFirstDay(),
			endDate: ym.addMonth(2).getLastDay()
		)
		
		return friendUseCase.mapScheduleToCalendar(response)
	}
}
