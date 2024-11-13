//
//  HomeDiaryEditView.swift
//  FeatureHome
//
//  Created by 박민서 on 10/30/24.
//

import SwiftUI
import SharedDesignSystem
import SharedUtil
import _PhotosUI_SwiftUI
import ComposableArchitecture

public struct HomeDiaryEditView: View {
    
    @Perception.Bindable var store: StoreOf<HomeDiaryEditStore>
    
    public init(store: StoreOf<HomeDiaryEditStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                
                DatePlaceView(store: store)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 24)
                
                EnjoyRateView(store: store)
                    .padding(.horizontal, 45)
                    .padding(.bottom, 16)
                
                ContentView(store: store)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                DiaryImageView(store: store)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                NamoButton(
                    title: store.isRevise ? "변경 내용 저장" : "기록 저장",
                    font: .pretendard(.bold, size: 15),
                    cornerRadius: 0,
                    verticalPadding: 30,
                    type: store.saveButtonState,
                    action: {
                        store.send(.tapSaveDiaryButton)
                    }
                )
            }
            .namoNabBar(center: {
                Text(store.scheduleName)
                    .font(.pretendard(.bold, size: 22))
            }, left: {
                Button(action: {
                    store.send(.tapBackButton, animation: .default)
                }, label: {
                    Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
                        .frame(width: 32, height: 32)
                })
            }, right: {
                Button(action: {
                    store.send(.tapDeleteDiaryButton, animation: .default)
                }, label: {
                    Image(asset: SharedDesignSystemAsset.Assets.icTrashcan)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .disabled(!store.isRevise)
                        .hidden(!store.isRevise)
                })
            })
            .ignoresSafeArea(.container, edges: .bottom)
            .namoToastView(
                isPresented: $store.showToast,
                title: "기록이 저장되었습니다.",
                isTabBarScreen: false
            )
            .namoAlertView(
                isPresented: $store.showAlert,
                title: store.alertContent.content.title,
                content: store.alertContent.content.message,
                confirmAction: {
                    store.send(.handleAlertConfirm)
                }
            )
        }
    }
}

// MARK: DatePlaceView
private extension HomeDiaryEditView {
    func DatePlaceView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        HStack(spacing: 25) {
            DateCircleView(monthString: store.monthString, dayString: store.dayString)
            
            VStack(alignment: .leading, spacing: 12) {
                DatePlaceItem(title: "날짜", content: store.dateString)
                DatePlaceItem(title: "장소", content: store.placeName)
            }
        }
    }
    
    func DateCircleView(monthString: String, dayString: String) -> some View {
        VStack {
            Text(monthString)
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            
            Text(dayString)
                .font(.pretendard(.bold, size: 36))
                .foregroundStyle(Color.mainText)
        }
        .padding(20)
        .background {
            Circle()
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.15), radius: 8)
        }
    }
    
    func DatePlaceItem(title: String, content: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            
            Text(content)
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        }
    }
}

// MARK: EnojoyRateView
private extension HomeDiaryEditView {
    func EnjoyRateView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        HStack {
            Text("재미도")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            Spacer()
            EnjoyCountView(store: store)
        }
    }
    
    func EnjoyCountView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                let isFilled = index < store.enjoyRating
                Image(asset: isFilled ? SharedDesignSystemAsset.Assets.icHeartSelected : SharedDesignSystemAsset.Assets.icHeart)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        store.send(.tapEnjoyRating(index + 1), animation: .default)
                    }
            }
        }
    }
}

// MARK: ContentView
private extension HomeDiaryEditView {
    
    func ContentView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        VStack(spacing: 10) {
            ContentInputView(store: store)
            ContentFooterView(
                count: store.contentString.count,
                maxCount: HomeDiaryEditStore.contentLimit,
                isValid: store.isContentValid
            )
        }
    }
    
    func ContentInputView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        HStack(spacing: 0) {
            // 좌측 고정 빨간 박스
            Rectangle()
                .fill(Color.namoPink)
                .frame(width: 10)
            // 다중 줄 텍스트 입력
            TextEditor(text: Binding(get: { store.contentString }, set: { store.send(.typeContent($0)) }))
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(Color.mainText)
                .scrollContentBackground(.hidden)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .overlay(
                    Text("내용 입력")
                        .font(.pretendard(.bold, size: 14))
                        .foregroundStyle(Color.textUnselected)
                        .opacity(store.contentString.isEmpty ? 1 : 0)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16),
                    alignment: .topLeading
                )
        }
        .frame(height: 150)
        .background(Color.itemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func ContentFooterView(count: Int, maxCount: Int, isValid: Bool) -> some View {
        HStack {
            Spacer()
            Text("\(count) / \(maxCount)")
                .font(.pretendard(.bold, size: 12))
                .foregroundStyle(isValid ? Color.textUnselected : Color.mainOrange)
        }
    }
}

// MARK: DiaryImageView
private extension HomeDiaryEditView {
    
    func DiaryImageView(store: StoreOf<HomeDiaryEditStore>) -> some View {
        
        PhotosPicker(selection: Binding(get: { store.selectedItems }, set: { newItems in
            if let newItem = newItems.last, newItems.count > store.selectedItems.count {
                store.send(.selectPhoto(newItem))
            }
        }), maxSelectionCount: 3) {
            ForEach(Array(store.selectedImages.enumerated()), id: \.self.element) { (offset, imageData) in
                DiaryImageListItemView(
                    image: UIImage(data: imageData) ?? UIImage(),
                    index: offset,
                    store: store
                )
            }
            
            if store.selectedImages.count < 3 {
                Image(asset: SharedDesignSystemAsset.Assets.noPicture)
                    .resizable()
                    .frame(width: 92, height: 92)
            }
        }
    }
    
    func DiaryImageListItemView(image: UIImage, index: Int, store: StoreOf<HomeDiaryEditStore>) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: 92, height: 92)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .overlay {
                        Image(asset: SharedDesignSystemAsset.Assets.icXmark)
                    }
                    .offset(x: 10, y: -10)
                    .onTapGesture {
                        store.send(.deleteImage(index), animation: .default)
                    }
            }
    }
}
