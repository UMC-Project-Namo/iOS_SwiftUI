//
//  TabBarView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/27/24.
//

import SwiftUI

struct TabBarView: View {
    @Binding public var currentTab: Int
    @Namespace var namespace
    
    public let tabBarOptions: [String]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                Spacer()
                ForEach(Array(tabBarOptions.enumerated()), id: \.self.0) { index, item in
                    Button(action: {
                        withAnimation {
                            currentTab = index
                        }
                    }, label: {
                        VStack(spacing: 8) {
                            let isSelected = currentTab == index
                            Text(item)
                                .font(.pretendard(.bold, size: 15))
                                .foregroundStyle(isSelected ? Color.namoOrange : Color.textPlaceholder)
                                .padding(.horizontal, 10)
                            
                            if isSelected {
                                Color.namoOrange
                                    .frame(height: 1)
                                    .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame)
                            } else {
                                Color.clear
                                    .frame(height: 1)
                            }
                        }
                        .fixedSize()
                        .animation(.spring, value: currentTab)
                    })
                    .buttonStyle(.plain)
                    Spacer()
                }
            }
            .zIndex(10)
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(Color.mainGray)
        }
            .background(.white)
            
    }
}
