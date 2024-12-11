//
//  NamoEntireImageView.swift
//  SharedDesignSystem
//
//  Created by 박민서 on 12/11/24.
//

import SwiftUI
import ComposableArchitecture
import SharedDesignSystem

// MARK: Reducer
@Reducer
public struct HomeEntireImageStore {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init(imgDataList: [Data], currentPage: Int = 0) {
            self.imgDataList = imgDataList
            self.currentPage = currentPage
        }
        
        let imgDataList: [Data]
        var currentPage: Int
        // 토스트
        var showToast: Bool = false
        var toast: Toast = .none
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case tapBackButton
        case tapDownloadButton
        case pageChanged(page: Int)
        case showToast(Toast)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
            
            case .tapBackButton:
                print("dismiss")
                return .none
            case .tapDownloadButton:
                print("download")
                return .send(.showToast(.saveSuccess))
                
            case let .pageChanged(newPage):
                state.currentPage = newPage
                return .none
                
            case .showToast(let toast):
                state.toast = toast
                state.showToast = true
                return .none
            }
        }
    }
}

extension HomeEntireImageStore {
    public enum Toast {
        case saveSuccess
        case saveFailed
        case none
        
        var content: String {
            switch self {
            case .saveSuccess:
                return "이미지가 저장되었습니다."
            case .saveFailed:
                return "이미지 저장에 실패했습니다.\n다시 시도해주세요."
            case .none:
                return ""
            }
        }
    }
}

// MARK: NamoEntireImageView
public struct HomeEntireImageView: View {
    
    @Perception.Bindable var store: StoreOf<HomeEntireImageStore>

    public init(store: StoreOf<HomeEntireImageStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            ZStack() {
//                TabView(selection: Binding(
//                    get: { store.currentPage },
//                    set: { store.send(.pageChanged($0)) }
//                )) {
//                    ForEach(store.imgDataList) { imageData in
//                        if let uiImage = UIImage(data: imageData.imageData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .scaledToFit()
//                                .tag(store.imgDataList.firstIndex(of: imageData) ?? 0)
//                        }
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .ignoresSafeArea(.container, edges: .bottom)
                
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
    HomeEntireImageView(store: .init(initialState: HomeEntireImageStore.State(imgDataList: [])) {
        HomeEntireImageStore()
    })
}
