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

struct TempStore {
    let isRevise: Bool = false // 외부 주입
    let recordName: String = "코딩 스터디" // 외부 주입
    let monthString: String = "Oct"
    let dayString: String = Date().toDD()
    let dateString: String = Date().toYMDEHM() // 외부 주입?
    let placeName: String = "강남역" // 외부 주입?
    let enjoyRating: Int = 1
    @State var contentString: String = ""
    let contentLimit: Int = 200
    @State var selectedImages: [UIImage] = []
    @State var selectedItems: [PhotosPickerItem] = []
    var saveButtonState: NamoButton.NamoButtonType = .inactive
}

extension TempStore {
    var contentCount: Int { contentString.count }
}

public struct HomeDiaryEditView: View {
    
    var store = TempStore()
    
    public init() {}
    
    public var body: some View {
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
                    switch store.saveButtonState {
                    case .active:
                        print("기록 저장")
                    default:
                        break
                    }
                }
            )
        }
        .namoNabBar(center: {
            Text(store.recordName)
                .font(.pretendard(.bold, size: 22))
        }, left: {
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
                    .frame(width: 32, height: 32)
            })
        }, right: {
            Button(action: {}, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icTrashcan)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .disabled(!store.isRevise)
                    .hidden(!store.isRevise)
            })
        })
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

// MARK: DatePlaceView
private extension HomeDiaryEditView {
    func DatePlaceView(store: TempStore) -> some View {
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
        HStack(spacing: 12) {
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
    func EnjoyRateView(store: TempStore) -> some View {
        HStack {
            Text("재미도")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            Spacer()
            EnjoyCountView(rate: store.enjoyRating)
        }
    }
    
    func EnjoyCountView(rate: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                let isFilled = index < rate
                Image(asset: isFilled ? SharedDesignSystemAsset.Assets.icHeartSelected : SharedDesignSystemAsset.Assets.icHeart)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
        }
    }
}

// MARK: ContentView
private extension HomeDiaryEditView {
    
    func ContentView(store: TempStore) -> some View {
        VStack(spacing: 10) {
            ContentInputView(store: store)
            ContentFooterView(count: store.contentCount, maxCount: store.contentLimit)
        }
    }
    
    func ContentInputView(store: TempStore) -> some View {
        HStack(spacing: 0) {
            // 좌측 고정 빨간 박스
            Rectangle()
                .fill(Color.namoPink)
                .frame(width: 10)
            // 다중 줄 텍스트 입력
            TextEditor(text: store.$contentString)
                .font(.pretendard(.regular, size: 14))
                .foregroundStyle(Color.mainText)
                .backgroundStyle(Color.itemBackground)
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
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    func ContentFooterView(count: Int, maxCount: Int) -> some View {
        HStack {
            Spacer()
            Text("\(count) / \(maxCount)")
                .font(.pretendard(.bold, size: 12))
                .foregroundStyle(Color.textUnselected)
        }
    }
}

// MARK: DiaryImageView
private extension HomeDiaryEditView {
    
    func DiaryImageView(store: TempStore) -> some View {
        PhotosPicker(selection: store.$selectedItems, maxSelectionCount: 3) {
            ForEach(Array(store.selectedImages.enumerated()), id: \.self.element) { (offset, image) in
                Image(uiImage: image)
                    .resizable()
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
                                store.selectedImages.remove(at: offset)
                            }
                    }
            }
            if store.selectedImages.count < 3 {
                Image(asset: SharedDesignSystemAsset.Assets.noPicture)
                    .resizable()
                    .frame(width: 92, height: 92)
            }
        }
    }
}
