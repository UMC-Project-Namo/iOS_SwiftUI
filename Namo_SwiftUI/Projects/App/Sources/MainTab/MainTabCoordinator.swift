//
//  MainTabCoordinator.swift
//  Namo_SwiftUI
//
//  Created by 권석기 on 9/20/24.
//

import Foundation

import Feature
import Domain
import Shared

import ComposableArchitecture
import TCACoordinators

@Reducer
struct MainTabCoordinator {
    
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
		case home(HomeCoordinator.Action)
        case moim(MoimCoordinator.Action)
		
		case viewOnAppear
		// 카테고리 리스트 response
		case getAllCategoryResponse(categories: [NamoCategory])
    }
    
    @ObservableState
    struct State: Equatable {
        static let intialState = State(currentTab: .home, home: .initialState, moim: .initialState)
        
        var currentTab: Tab
		var home: HomeCoordinator.State
        var moim: MoimCoordinator.State
        
		
		@Shared(.inMemory(SharedKeys.categories.rawValue)) var categories: [NamoCategory] = []
    }
	
	@Dependency(\.categoryUseCase) var categoryUseCase
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
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
