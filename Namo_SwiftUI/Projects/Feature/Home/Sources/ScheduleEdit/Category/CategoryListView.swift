//
//  CategoryListView.swift
//  FeatureHome
//
//  Created by 정현우 on 10/5/24.
//

import SwiftUI

import ComposableArchitecture

import SharedDesignSystem

struct CategoryListView: View {
	let store: StoreOf<CategoryListStore>
	
	var body: some View {
		WithPerceptionTracking {
			VStack {
				navigationBar
					.padding(.horizontal, 19)
				
				ScrollView(.vertical, showsIndicators: false) {
					categoryList
				}
				.padding(.horizontal, 30)
			}
		}
		.toolbar(.hidden, for: .navigationBar)
	}
	
	private var navigationBar: some View {
		ScheduleEditNavigationBar(
			title: "카테고리",
			leftButton: {
				Button(
					action: {
						store.send(.backBtnTapped)
					},
					label: {
						HStack {
							Image(asset: SharedDesignSystemAsset.Assets.icLeft)
							
							Text("일정")
								.font(.pretendard(.regular, size: 15))
						}
					}
				)
				.tint(Color.mainText)
			}
		)
	}
	
	private var categoryList: some View {
		WithPerceptionTracking {
			VStack(spacing: 20) {
				ForEach(store.categories, id: \.categoryId) { category in
					HStack(spacing: 16) {
						Button(
							action: {
								store.send(.categorySelect(category))
							},
							label: {
								ColorCircleView(
									color: PalleteColor(rawValue: category.colorId)?.color ?? .clear,
									isChecked: store.schedule.category.categoryId == category.categoryId
								)
								.frame(width: 20, height: 20)
							}
						)
						
						Button(
							action: {
								store.send(.editCategoryTapped(category))
							},
							label: {
								HStack {
									Text(category.categoryName)
										.font(.pretendard(.regular, size: 15))
										.foregroundStyle(Color.mainText)
									
									Image(asset: SharedDesignSystemAsset.Assets.icRight)
									
									Spacer()
								}
							}
						)
					}
					
				}
				HStack {
					Button(
						action: {
							store.send(.newCategoryTapped)
						},
						label: {
							HStack(spacing: 16) {
								Image(asset: SharedDesignSystemAsset.Assets.icAdded)
									.resizable()
									.frame(width: 20, height: 20)
								
								Text("새 카테고리 추가")
									.font(.pretendard(.regular, size: 15))
							}
						}
					)
					.tint(Color.mainText)
					
					Spacer()
				}
			}
		}
	}
}
