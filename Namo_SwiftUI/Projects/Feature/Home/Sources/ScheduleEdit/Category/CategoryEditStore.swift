//
//  CategoryEditStore.swift
//  FeatureHome
//
//  Created by 정현우 on 10/5/24.
//

import ComposableArchitecture

import DomainCategory
import SharedUtil
import SharedDesignSystem

@Reducer
public struct CategoryEditStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		// 카테고리 생성인지 편집인지
		var isNewCategory: Bool
		// 생성/편집 하는 카테고리
		var category: NamoCategory
		// 선택한 색상
		var selectedColor: PalleteColor?
		
		public init(
			isNewCategory: Bool,
			category: NamoCategory = NamoCategory(categoryId: -1, categoryName: "", colorId: -1, baseCategory: false, shared: false)
		) {
			self.isNewCategory = isNewCategory
			self.category = category
			
			// 편집인 경우 기존 색상 적용
			if isNewCategory {
				self.selectedColor = nil
			} else {
				self.selectedColor = PalleteColor(rawValue: category.colorId)
			}
			
		}
	}
	
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		
		// 뒤로가기
		case backBtnTapped
		// 저장하기
		case saveBtnTapped
		// 저장 완료
		case saveCompleted
	}
	
	@Dependency(\.categoryUseCase) var categoryUseCase
	
	public var body: some ReducerOf<Self> {
		BindingReducer()
		
		Reduce { state, action in
			switch action {
			case .binding:
				return .none
				
			case .backBtnTapped:
				return .none
				
			case .saveBtnTapped:
				let categoryEdit = CategoryEdit(
					categoryName: state.category.categoryName,
					colorId: state.selectedColor?.rawValue ?? 0,
					isShared: state.category.shared
				)
				return .run {[
					isNewCategory = state.isNewCategory,
					categoryId = state.category.categoryId
				] send in
					if isNewCategory {
						do {
							try await categoryUseCase.postCategory(data: categoryEdit)
							await send(.saveCompleted)
						} catch (let error) {
							// TODO: 에러처리
							print(error.localizedDescription)
						}
					} else {
						do {
							try await categoryUseCase.patchCategory(categoryId: categoryId, data: categoryEdit)
							await send(.saveCompleted)
						} catch (let error) {
							// TODO: 에러처리
							print(error.localizedDescription)
						}
					}
				}
				
			case .saveCompleted:
				
				return .none
			}
		}
	}
	
}
