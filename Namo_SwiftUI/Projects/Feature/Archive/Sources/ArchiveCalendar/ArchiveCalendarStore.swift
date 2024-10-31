//
//  ArchiveCalendarStore.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI

import ComposableArchitecture

@Reducer
public struct ArchiveCalendarStore {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
	}
	
	public enum Action {
		// 뒤로가기
		case backBtnTapped
	}
	
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				case .backBtnTapped:
				return .none
			}
		}
	}
	
}
