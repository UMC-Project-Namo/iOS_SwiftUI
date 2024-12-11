//
//  NamoEntireImageView.swift
//  SharedDesignSystem
//
//  Created by 박민서 on 12/11/24.
//

import SwiftUI
import ComposableArchitecture
import SharedDesignSystem
import SharedUtil

public struct HomeEntireImageView: View {
    
    @Perception.Bindable var store: StoreOf<HomeEntireImageStore>

    public init(store: StoreOf<HomeEntireImageStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack() {
                ImageCarouselView(store: store)
                
                VStack {
                    TopBar(totalImgCount: store.imgDataList.count, currentImgIndex: $store.currentPage)
                    Spacer()
                }
            }
            .background(.black)
            .namoToastView(
                isPresented: $store.showToast,
                title: store.toast.content,
                isTabBarScreen: false
            )
        }
    }
}

// MARK: Top Bar
private extension HomeEntireImageView {
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
                Text("\(currentImgIndex.wrappedValue + 1)") // 표시는 index + 1
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

// MARK: ImageCarouselView
private extension HomeEntireImageView {
    func ImageCarouselView(store: StoreOf<HomeEntireImageStore>) -> some View {
        TabView(selection: Binding(
            get: { store.currentPage },
            set: { store.send(.pageChanged(page: $0)) }
        )) {
            ForEach(store.imgDataList, id: \.id) { imageData in
                if let uiImage = UIImage(data: imageData.data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .tag(store.imgDataList.firstIndex(of: imageData) ?? 0)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

#Preview {
    HomeEntireImageView(store: .init(initialState: HomeEntireImageStore.State(imgDataList: [])) {
        HomeEntireImageStore()
    })
}
