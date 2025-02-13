//
//  DeleteCircleButton.swift
//  FeatureHome
//
//  Created by 정현우 on 10/3/24.
//

import SwiftUI

public struct DeleteCircleButton: View {
    
    private let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
	
    public var body: some View {
		ZStack {
			Circle()
				.fill(.white)
				.frame(width: 40, height: 40)
				.shadow(radius: 2)
			
            Image(asset: SharedDesignSystemAsset.Assets.icDeleteSchedule)
				.resizable()
				.frame(width: 24, height: 24)
			
		}
		.offset(y: -20)
		.onTapGesture(perform: {
			action()
		})
	}
}
