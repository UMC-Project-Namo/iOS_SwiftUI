//
//  NamoEntireImageView.swift
//  SharedDesignSystem
//
//  Created by 박민서 on 12/11/24.
//

import SwiftUI

public struct NamoEntireImageView: View {
    @State var image: Image = Image(asset: SharedDesignSystemAsset.Assets.noGroup)
    @State var showToast: Bool = true
    @State var title: String = "이미지가 저장되었습니다."
    
    public var body: some View {
        ZStack() {
            image
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.container, edges: .bottom)
            
            VStack {
                TopBar(totalImgCount: 2, currentImgIndex: .constant(1))
                Spacer()
            }
        }
        .background(.black)
        .namoToastView(
            isPresented: $showToast,
            title: title,
            isTabBarScreen: false
        )
    }
}

// MARK: Top Bar
private extension NamoEntireImageView {
    func TopBar(totalImgCount: Int, currentImgIndex: Binding<Int>) -> some View {
        HStack {
            // Back button
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icArrowLeft)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
            })
            
            Spacer()
            
            // Image number
            HStack(spacing: 10) {
                Text("\(currentImgIndex.wrappedValue)")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(.white)
                
                Text("/")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(Color.textPlaceholder)
                
                Text("\(totalImgCount)")
                    .font(.pretendard(.bold, size: 18))
                    .foregroundStyle(Color.textPlaceholder)
            }
            
            Spacer()
            
            // Download button
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icDownload)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
            })
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color.colorBlack.opacity(0.5))
    }
}

#Preview {
    NamoEntireImageView()
}
