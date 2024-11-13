//
//  ArchiveCoordinatorView.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import SwiftUI

import ComposableArchitecture
import TCACoordinators

public struct ArchiveCoordinatorView: View {
	let store: StoreOf<ArchiveCoordinator>
	
	public init(store: StoreOf<ArchiveCoordinator>) {
		self.store = store
	}
	
	public var body: some View {
		TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
			switch screen.case {
			case let .archiveMain(store):
				ArchiveMainView(store: store)
				
			case let .archiveCalendar(store):
				ArchiveCalendarView(store: store)
			}
		}
	}
}
