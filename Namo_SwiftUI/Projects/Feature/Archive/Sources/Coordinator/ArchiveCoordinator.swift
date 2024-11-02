//
//  ArchiveCoordinator.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators

@Reducer(state: .equatable)
public enum ArchvieScreen {
	case archiveMain(ArchiveMainStore)
	case archiveCalendar(ArchiveCalendarStore)
}

@Reducer
public struct ArchiveCoordinator {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		var routes: [Route<ArchvieScreen.State>] = []
		
		public static let initialState = State(
			routes: [.root(.archiveMain(.init()))]
		)
	}
	
	public enum Action {
		case router(IndexedRouterActionOf<ArchvieScreen>)
	}
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				// 아카이브 메인에서
			case .router(.routeAction(_, action: .archiveMain(let action))):
				switch action {
				case .calendarBtnTapped:
					// 아카이브 캘린더로
					state.routes.push(.archiveCalendar(.init()))
					return .none
					
				default:
					return .none
				}
				
				// 아카이브 캘린더에서
			case .router(.routeAction(_, action: .archiveCalendar(let action))):
				switch action {
				case .backBtnTapped:
					// 뒤로가기
					state.routes.pop()
					return .none
					
				default:
					return .none
				}
				
				
			default:
				return .none
			}
		}
		.forEachRoute(\.routes, action: \.router)
	}
	
	
}
