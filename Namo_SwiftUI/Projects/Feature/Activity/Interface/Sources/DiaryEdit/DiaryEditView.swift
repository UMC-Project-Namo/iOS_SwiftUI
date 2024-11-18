//
//  DiaryEditView.swift
//  FeatureActivity
//
//  Created by 권석기 on 11/18/24.
//

import SwiftUI

import SharedDesignSystem

import ComposableArchitecture

public struct DiaryEditView: View {    
    let store: StoreOf<DiaryEditStore>
    
    public init(store: StoreOf<DiaryEditStore>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            
        }
        .namoNabBar {
            Text("나모 3기 회식")
                .font(.pretendard(.bold, size: 22))
        } left: {
            NamoBackButton(action: {store.send(.backButtonTapped)})
        }
    }
}
