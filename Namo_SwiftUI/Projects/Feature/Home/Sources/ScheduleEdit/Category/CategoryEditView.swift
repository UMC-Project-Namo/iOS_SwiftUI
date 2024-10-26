//
//  CategoryEditView.swift
//  FeatureHome
//
//  Created by 정현우 on 10/5/24.
//

import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

struct CategoryEditView: View {
	@Perception.Bindable var store: StoreOf<CategoryEditStore>
	
	var body: some View {
		WithPerceptionTracking {
			
			VStack(spacing: 0) {
				navigationBar
					.padding(.horizontal, 19)
				
				VStack(spacing: 32) {
					title
					
					colorPallete
					
					shareToggle
					
					Spacer()
				}
				.padding(.top, 12)
				.padding(.horizontal, 30)
			}
		}
		.toolbar(.hidden, for: .navigationBar)
	}
	
	private var navigationBar: some View {
		ScheduleEditNavigationBar(
			title: store.isNewCategory ? "새 카테고리" : "카테고리 편집",
			leftButton: {
				Button(
					action: {
						store.send(.backBtnTapped)
					},
					label: {
						HStack {
							Image(asset: SharedDesignSystemAsset.Assets.icLeft)
							
							Text("카테고리")
								.font(.pretendard(.regular, size: 15))
						}
					}
				)
				.tint(Color.mainText)
			},
			rightButton: {
				Button(
					action: {
						store.send(.saveBtnTapped)
					},
					label: {
						Text("저장")
							.font(.pretendard(.regular, size: 15))
					}
				)
				.tint(Color.mainText)
			}
		)
	}
	
	private var title: some View {
		TextField("새 카테고리", text: $store.category.categoryName)
			.font(.pretendard(.bold, size: 22))
			.padding(.top, 12)
			.foregroundStyle(Color(asset: SharedDesignSystemAsset.Assets.mainText))
	}
	
	private var colorPallete: some View {
		NamoPallete(selectedColor: $store.selectedColor, itemName: "색상")
	}
	
	private var shareToggle: some View {
		Toggle(isOn: $store.category.shared) {
			Text("공개 설정")
				.font(.pretendard(.bold, size: 15))
				.foregroundColor(.mainText)
		}
		.tint(Color.colorToggle)
	}
}
