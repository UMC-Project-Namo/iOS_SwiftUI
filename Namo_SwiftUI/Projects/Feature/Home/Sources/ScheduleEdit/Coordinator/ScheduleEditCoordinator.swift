//
//  ScheduleEditCoordinator.swift
//  FeatureHome
//
//  Created by 정현우 on 10/3/24.
//

import ComposableArchitecture
import TCACoordinators

import DomainSchedule
import DomainCategory
import SharedUtil

@Reducer(state: .equatable)
public enum ScheduleEditScreen {
	case scheduleEdit(ScheduleEditStore)
	case categoryList(CategoryListStore)
	case categoryEdit(CategoryEditStore)
	case reminderSetting(ReminderSettingStore)
}

@Reducer
public struct ScheduleEditCoordinator {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		var routes: [Route<ScheduleEditScreen.State>]
		
		// 하위 뷰에서 사용할 현재 편집 중인 스케쥴
		@Shared var schedule: ScheduleEdit
		// 편집의 경우 스케쥴 id
		var scheduleId: Int
		
		@Shared(.inMemory(SharedKeys.categories.rawValue)) var categories: [NamoCategory] = []
		
		// 신규 스케쥴인지
		var isNewSchedule: Bool
		// 삭제 버튼 보이게 할 지 안보이게 할지
		// 라우팅 할 때 관리
		var showDeleteButton: Bool
			
		public init(
			isNewSchedule: Bool,
			schedule: ScheduleEdit,
			scheduleId: Int = -1
		) {
			self.routes = []
			self._schedule = Shared(schedule)
			self.scheduleId = scheduleId
			self.isNewSchedule = isNewSchedule
			self.showDeleteButton = !isNewSchedule
			
			// scheduleEdit에 자신의 Shared 객체를 넘겨줌
			self.routes = [
				.root(
					.scheduleEdit(
						.init(
							isNewSchedule: isNewSchedule,
							schedule: $schedule,
							scheduleId: scheduleId
						)
					),
					embedInNavigationView: true
				)
			]
		}

	}
	
	public enum Action {
		case router(IndexedRouterActionOf<ScheduleEditScreen>)
		
		case checkAndShowDeleteButton
		case hideDeleteButton
		
		case deleteButtonTapped
		case categoryDeleteCompleted
		case scheduleDeleleteCompleted
		
		case getAllCategoryList
		case getAllCategoryResponse([NamoCategory])
		
	}
	
	@Dependency(\.categoryUseCase) var categoryUseCase
	@Dependency(\.scheduleUseCase) var scheduleUseCase
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				
			case .router(.routeAction(_, action: .scheduleEdit(.selectCategoryTapped))):
				// 스케쥴 생성/편집에서 카테고리 리스트 push
				state.routes.push(.categoryList(.init(schedule: state.$schedule)))
				
				return .send(.hideDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .categoryList(.backBtnTapped))):
				// 카테고리 리스트 pop
				state.routes.pop()
				
				return .send(.checkAndShowDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .categoryList(.newCategoryTapped))):
				// 카테고리 리스트에서 카테고리 생성 push
				state.routes.push(
					.categoryEdit(
						.init(
							isNewCategory: true
						)
					)
				)
				return .none
				
			case .router(.routeAction(_, action: .categoryList(.editCategoryTapped(let category)))):
				// 카테고리 리스트에서 카테고리 편집 push
				state.routes.push(
					.categoryEdit(
						.init(
							isNewCategory: false,
							category: category
						)
					)
				)
				
				state.showDeleteButton = true
				
				return .none
				
			case .router(.routeAction(_, action: .categoryEdit(.backBtnTapped))):
				// 카테고리 생성/편집 뒤로가기
				state.routes.pop()
				
				return .send(.hideDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .scheduleEdit(.reminderBtnTapped))):
				// 일정 생성/편집에서 알림 push
				state.routes.push(.reminderSetting(.init(schedule: state.$schedule)))
				return .send(.hideDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .reminderSetting(.backBtnTapped))):
				// 알림 pop
				state.routes.pop()
				
				return .send(.checkAndShowDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .reminderSetting(.saveReminderBtnTapped))):
				// 알림 pop
				state.routes.pop()
				
				return .send(.checkAndShowDeleteButton, animation: .default)
				
			case .router(.routeAction(_, action: .categoryEdit(.saveCompleted))):
				// 카테고리 편집/생성 완료 후 pop
				state.routes.pop()
				
				// 카테고리 목록 새로고침
				return .merge(
					.send(.hideDeleteButton),
					.send(.getAllCategoryList)
				)
				
			case .checkAndShowDeleteButton:
				// schedule edit으로 돌아오면 삭제 버튼 보여질지 체크
				if !state.isNewSchedule { state.showDeleteButton = true }
				
				return .none
				
			case .hideDeleteButton:
				state.showDeleteButton = false
				
				return .none
				
			case .deleteButtonTapped:
				// TODO: 삭제 동그라미 버튼을 각 뷰에 넣으면 잘림...
				// 임시로 코디네이터에서 로직 처리
				switch state.routes.last?.screen {
				case .categoryEdit(let categoryState):
					let currentCategory = categoryState.category
					return .run { send in
						// 삭제 요청
						do {
							try await categoryUseCase.deleteCategory(categoryId: currentCategory.categoryId)
							await send(.categoryDeleteCompleted)
						} catch (let error) {
							// TODO: 에러 핸들링
							print(error.localizedDescription)
						}
					}
					
				case .scheduleEdit(_):
					return .run {[scheduleId = state.scheduleId] send in
						// 삭제 요청
						do {
							try await scheduleUseCase.deleteSchedule(scheduleId)
							await send(.scheduleDeleleteCompleted)
						} catch (let error) {
							// TODO: 에러 핸들링
							print(error.localizedDescription)
						}
					}
					
				default:
					return .none
				}
				
			case .categoryDeleteCompleted:
				state.routes.pop()
				return .merge(
					.send(.hideDeleteButton),
					.send(.getAllCategoryList)
				)

				
			case .getAllCategoryList:
				
				return .run { send in
					do {
						let response = try await categoryUseCase.getAllCategory()
						await send(.getAllCategoryResponse(response))
					} catch (let error) {
						// TODO: 에러처리
						print(error.localizedDescription)

					}
				}
				
			case .getAllCategoryResponse(let categories):
				state.categories = categories
				return .none
				
			default:
				return .none
			}
		}
		.forEachRoute(\.routes, action: \.router)
		
	}
}

