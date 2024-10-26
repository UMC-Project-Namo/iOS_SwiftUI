//
//  HomeCoordinator.swift
//  FeatureHome
//
//  Created by 정현우 on 9/27/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

import SwiftUICalendar

@Reducer(state: .equatable)
public enum HomeScreen {
	case homeMain(HomeMainStore)
	case scheduleEditCoordinator(ScheduleEditCoordinator)
}

@Reducer
public struct HomeCoordinator {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		var routes: [Route<HomeScreen.State>]
		
		public static let initialState = State(
			routes: [.root(.homeMain(.init()), embedInNavigationView: true)]
		)
		
		// 일정 편집/수정에서 뒷 배경 어둡게
		var showBackgroundOpacity: Bool = false
	}
	
	public enum Action {
		case router(IndexedRouterActionOf<HomeScreen>)
		
		// 뒷 배경 어둡게 toggle
		case toggleBackgroundOpacity
		case dismiss
	}
	
	@Dependency(\.scheduleUseCase) var scheduleUseCase
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .toggleBackgroundOpacity:
				state.showBackgroundOpacity.toggle()
				
				return .none
				
			case .router(.routeAction(_, action: .homeMain(.archiveTapped))):
				return .none
			case let .router(.routeAction(_, action: .homeMain(.editSchedule(isNewSchedule, schedule, selectDate)))):
				// 홈에서 스케쥴 생성/편집 띄우기
				
				// Schedule -> ScheduleEdit으로 변환
				let scheduleEdit = scheduleUseCase.scheduleToScheduleEdit(schedule: schedule, selectDate: selectDate)
				state.routes.presentCover(
					.scheduleEditCoordinator(.init(
						isNewSchedule: isNewSchedule,
						schedule: scheduleEdit,
						scheduleId: schedule?.scheduleId ?? -1
					))
				)

				return .none
				
			case .router(.routeAction(_, action: .scheduleEditCoordinator(.router(.routeAction(_, action: .scheduleEdit(.closeBtnTapped)))))):
				// 스케쥴 생성/편집 닫기
				
				return .send(.dismiss)
				
			case .router(.routeAction(_, action: .scheduleEditCoordinator(.router(.routeAction(_, action: .scheduleEdit(.saveCompleted)))))):
				// 스케쥴 저장 완료 후
				NotificationCenter.default.post(name: .reloadCalendarViaNetwork, object: nil)
				
				return .send(.dismiss)
				
			case .router(.routeAction(_, action: .scheduleEditCoordinator(.scheduleDeleleteCompleted))):
				// 스케쥴 삭제 완료 후
				NotificationCenter.default.post(name: .reloadCalendarViaNetwork, object: nil)
				
				return .send(.dismiss)
				
			case .dismiss:
				state.showBackgroundOpacity = false
				state.routes.dismiss()
				
				return .none
				
			default:
				return .none
			}
		}
		.forEachRoute(\.routes, action: \.router)
	}
}
