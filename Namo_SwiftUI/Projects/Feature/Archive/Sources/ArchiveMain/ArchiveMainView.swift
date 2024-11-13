//
//  ArchiveMainView.swift
//  FeatureArchive
//
//  Created by 정현우 on 10/31/24.
//

import Foundation
import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

public struct ArchiveMainView: View {
	let store: StoreOf<ArchiveMainStore>
	
	public init(store: StoreOf<ArchiveMainStore>) {
		self.store = store
	}
	
	public var body: some View {
		WithPerceptionTracking {
			VStack(spacing: 0) {
				
			}
			.namoNabBar(
				center: {
					Text("보관함")
						.font(.pretendard(.bold, size: 16))
						.foregroundStyle(Color.colorBlack)
				},
				left: {
					Button(
						action: {
							store.send(.backBtnTapped)
						},
						label: {
							Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
						}
					)
				},
				right: {
					Button(
						action: {
							store.send(.calendarBtnTapped)
						},
						label: {
							Image(asset: SharedDesignSystemAsset.Assets.icCalendar)
						}
					)
				}
			)
		}
	}
}
