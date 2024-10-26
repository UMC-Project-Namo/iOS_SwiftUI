//
//  EmptyListView.swift
//  FeatureMoimInterface
//
//  Created by 권석기 on 9/10/24.
//

import SwiftUI
import SharedDesignSystem

public struct EmptyListView: View {
	let title: String
	
	public init(title: String) {
		self.title = title
	}
	
	public var body: some View {
		VStack {
			Spacer()
			Image(asset: SharedDesignSystemAsset.Assets.noGroup)
			
			Text(title)
				.font(.pretendard(.regular, size: 15))
				.multilineTextAlignment(.center)
				.foregroundStyle(Color.mainText)
				.padding(.top, 40)
			
			Spacer()
		}
	}
}


