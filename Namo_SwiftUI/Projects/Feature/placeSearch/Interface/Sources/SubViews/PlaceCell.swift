//
//  PlaceCell.swift
//  FeaturePlaceSearch
//
//  Created by 권석기 on 10/22/24.
//

import SwiftUI
import SharedDesignSystem

struct PlaceCell: View {
    let placeName: String
    let addressName: String
    let roadAddressName: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(placeName)
                        .font(.pretendard(.bold, size: 14))
                        .foregroundStyle(Color.mainText)                    
                    
                    Text(addressName)
                        .font(.pretendard(.regular, size: 11))
                        .foregroundStyle(Color.mainText)
                        .padding(.top, 7)
                    
                    Text(roadAddressName)
                        .font(.pretendard(.regular, size: 11))
                        .foregroundStyle(Color.mainText)
                        .padding(.top, 5)
                }
                
                Spacer()
                
                if isSelected {
                    Image(asset: SharedDesignSystemAsset.Assets.icCheckPlace)
                }
            }
            .padding(12)
        }
        .background(
            Color.itemBackground
        )
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 0)
    }
}

//#Preview {
//    PlaceCell()
//}
