//
//  NamoTabView.swift
//  SharedDesignSystem
//
//  Created by 권석기 on 11/6/24.
//

import SwiftUI

public enum Tab: CaseIterable {
    case home, group
    
    var iconName: SharedDesignSystemImages {
        switch self {
        case .home:
                .init(name: "ic_home")
        case .group:
                .init(name: "ic_group")
        }
    }
    
    var selectedIconName: SharedDesignSystemImages {
        switch self {
        case .home:
                .init(name: "ic_home_selected")
        case .group:
                .init(name: "ic_group_selected")
        }
    }
}

public struct NamoTabView: View {
    @Binding var currentTab: Tab
    
    public init(currentTab: Binding<Tab>) {
        self._currentTab = currentTab
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                Spacer()
                
                ForEach(Tab.allCases, id: \.hashValue) { tab in
                    Image(asset: currentTab == tab ? tab.selectedIconName : tab.iconName)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            currentTab = tab
                        }
                }
                
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .frame(height: 80)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 0)
        )
    }
    
}


