//
//  MainTabCoordinator.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import Foundation
import ComposableArchitecture
import TCACoordinators
import Feature
import Domain
import Shared


@Reducer
struct MainTabCoordinator {
    enum Tab: Hashable {
		case home
        case moim
    }
    
    enum Action {
		case home(HomeCoordinator.Action)
        case moim(MoimCoordinator.Action)
		
		case viewOnAppear
		// 카테고리 리스트 response
		case getAllCategoryResponse(categories: [NamoCategory])
    }
    
    @ObservableState
    struct State: Equatable {
		static let intialState = State(home: .initialState, moim: .initialState)
		var home: HomeCoordinator.State
        var moim: MoimCoordinator.State
		
		@Shared(.inMemory(SharedKeys.categories.rawValue)) var categories: [NamoCategory] = []
    }
	
	@Dependency(\.categoryUseCase) var categoryUseCase
    
    var body: some ReducerOf<Self> {
        // 탭은 Navigatin을 가지지 않고 각 Coordinator를 Scope로 설정
		Scope(state: \.home, action: \.home) {
			HomeCoordinator()
		}
        Scope(state: \.moim, action: \.moim) {
            MoimCoordinator()
        }
        Reduce { state, action in
            switch action {
			case .viewOnAppear:
				
				return .run { send in
					do {
						let response = try await categoryUseCase.getAllCategory()
						await send(.getAllCategoryResponse(categories: response))
					} catch(let error) {
						// TODO: 에러 핸들링
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
    }
}
