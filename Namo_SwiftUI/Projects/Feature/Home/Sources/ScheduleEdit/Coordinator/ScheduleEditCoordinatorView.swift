//
//  ScheduleEditCoordinatorView.swift
//  FeatureHome
//
//  Created by 정현우 on 10/3/24.
//

import SwiftUI

import ComposableArchitecture
import TCACoordinators

public struct ScheduleEditCoordinatorView: View {
	let store: StoreOf<ScheduleEditCoordinator>
	
	public init(store: StoreOf<ScheduleEditCoordinator>) {
		self.store = store
	}
	
	public var body: some View {
		TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
			switch screen.case {
			case let .scheduleEdit(store):
				ScheduleEditView(store: store)
				
			case let .categoryList(store):
				CategoryListView(store: store)
				
			case let .categoryEdit(store):
				CategoryEditView(store: store)
				
			case let .reminderSetting(store):
				ReminderSettingView(store: store)
			}
		}
		.clipShape(UnevenRoundedRectangle(cornerRadii: .init(
			topLeading: 15,
			topTrailing: 15)))
		.shadow(radius: 10)
		.overlay(alignment: .top) {
			if store.showDeleteButton {
				DeleteCircleButton(action: {
					store.send(.deleteButtonTapped)
				})
				.offset(y: -50)
			}
		}
		.offset(y: 100)
	}
}
