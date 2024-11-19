//
//  DiaryEditView.swift
//  FeatureActivity
//
//  Created by 권석기 on 11/18/24.
//

import SwiftUI
import PhotosUI

import SharedDesignSystem

import ComposableArchitecture

public struct DiaryEditView: View {
    @State private var tabItems: [Int] = [0]
    @State private var selection = 0
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var seletedImages: [UIImage] = []
    @State private var text = ""
    @FocusState private var textEditorFocused: Bool
    
    let store: StoreOf<DiaryEditStore>
    
    public init(store: StoreOf<DiaryEditStore>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            Spacer().frame(height: 15)
            dateView
            Spacer().frame(height: 20)
            participantList
            Spacer().frame(height: 16)
            allSettlement
            Spacer().frame(height: 16)
            diaryPages
            Spacer().frame(height: 16)
            addActivityButton
            Spacer().frame(height: 100)
        }
        .overlay(alignment: .bottom, content: {
            saveButton
        })
        .namoNabBar {
            navigationTitle
        } left: {
            NamoBackButton(action: {store.send(.backButtonTapped)})
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - Subviews

// MARK: - 다이어리 편집
extension DiaryEditView {
    private var diaryEditView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Text("일기장")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Image(asset: SharedDesignSystemAsset.Assets.icPrivate)
                        .renderingMode(.template)
                        .foregroundColor(Color.textPlaceholder)
                }
                
                HStack {
                    Text("재미도")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(0..<2, id: \.self) { _ in
                            Image(asset: SharedDesignSystemAsset.Assets.icHeartSelected)
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        Image(asset: SharedDesignSystemAsset.Assets.icHeart)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                }
                .padding(.top, 24)
                
                VStack(spacing: 10) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .focused($textEditorFocused)
                            .lineSpacing(5)
                            .font(.pretendard(.regular, size: 14))
                            .foregroundColor(Color.mainText)
                            .scrollContentBackground(.hidden)
                            .frame(height: 160)
                        
                        if text.isEmpty && !textEditorFocused {
                            Text("내용 입력")
                                .font(.pretendard(.bold, size: 14))
                                .foregroundStyle(Color.textUnselected)
                                .padding(.top, 18)
                                .padding(.bottom, 12)
                                .padding(.horizontal, 16)
                        }
                    }
                    .background(Color.itemBackground)
                    .cornerRadius(10)
                    .padding(.top, 16)
                    
                    HStack {
                        Spacer()
                        Text("\(text.count) / 200")
                            .font(.pretendard(.bold, size: 12))
                            .foregroundStyle(Color.textUnselected)
                    }
                }
                
                photoPickerView
                    .padding(.top, 20)
            }
            .padding(20)
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 6)
        .padding(.horizontal, 25)
    }
}

// MARK: - 정산페이지
extension DiaryEditView {
    private var allSettlement: some View {
        HStack {
            Text("전체 정산")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            Spacer()
            Button(action: {}, label: {
                HStack(spacing: 8) {
                    Text("0원")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                    Image(asset: SharedDesignSystemAsset.Assets.icRight)
                }
            })
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15),
                radius: 6)
        .padding(.horizontal, 25)
    }
}

// MARK: - 참석자 목록
extension DiaryEditView {
    private var participantList: some View {
        VStack(spacing: 0) {
            HStack {
                Text("참석자 (10)")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(asset: SharedDesignSystemAsset.Assets.icUp)
                })
            }
        }
        .padding(.horizontal, 25)
    }
}

// MARK: - 날짜 & 장소
extension DiaryEditView {
    private var dateView: some View {
        HStack(spacing: 25) {
            VStack {
                Text("AUG")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                
                Text("07")
                    .font(.pretendard(.bold, size: 36))
                    .foregroundStyle(Color.mainText)
            }
            .padding(20)
            .background {
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.15), radius: 8)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Text("날짜")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Text("2024.08.07 (수) 08:00")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                
                HStack(spacing: 12) {
                    Text("장소")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Text("없음")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - 사진 선택
extension DiaryEditView {
    private var photoPickerView: some View {
        HStack {
            PhotosPicker(selection: $selectedItems, maxSelectionCount: 3) {
                ForEach(Array(seletedImages.enumerated()), id: \.self.element) { (offset, image) in
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
                                    seletedImages.remove(at: offset)
                                }
                        }
                }
                if seletedImages.count < 3 {
                    Image(asset: SharedDesignSystemAsset.Assets.noPicture)
                        .resizable()
                        .frame(width: 92, height: 92)
                }
            }
            
            Spacer()
        }
        .onChange(of: selectedItems, perform: { value in
            
        })
    }
}

// MARK: - 활동 기록&다이어리 보관함
extension DiaryEditView {
    private var diaryPages: some View {
        VStack {
            TabView(selection: $selection) {
                ForEach(tabItems, id: \.self) { index in
                    let isFirstPage = index == tabItems.count - 1
                    if isFirstPage {
                        diaryEditView
                    }
                    else {
                        activityView
                    }
                }
            }
            .frame(height: 450)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack {
                ForEach(tabItems, id: \.self) { index in
                    if index == tabItems.count - 1 {
                        Rectangle()
                            .cornerRadius(2)
                            .frame(width: index == selection ? 24 : 10, height: 10)
                            .foregroundStyle(index == selection ? Color.namoOrange : Color.textUnselected)
                            .animation(.easeInOut, value: selection)
                    } else {
                        Rectangle()
                            .cornerRadius(index == selection ? 12 : 5)
                            .frame(width: index == selection ? 24 : 10, height: 10)
                            .foregroundStyle(index == selection ? Color.namoOrange : Color.textUnselected)
                            .animation(.easeInOut, value: selection)
                    }
                }
            }
        }
    }
}

// MARK: - 활동 기록
extension DiaryEditView {
    private var activityView: some View {
        VStack {
            VStack {
                HStack {
                    TextField("", text: .constant(""), prompt: Text("새 활동"))
                        .font(.pretendard(.bold, size: 18))
                    
                    HStack(spacing: 12) {
                        Image(asset: SharedDesignSystemAsset.Assets.icView)
                        Rectangle()
                            .frame(width: 1, height: 12)
                            .foregroundColor(Color.textUnselected)
                        Image(asset: SharedDesignSystemAsset.Assets.icTrash)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 32)
                
                HStack {
                    Text("시작")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Text("2024.08.07 (수) 12:00 PM")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 16)
                
                HStack {
                    Text("종료")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Text("2024.08.07 (수) 12:00 PM")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 16)
                
                HStack {
                    Text("장소")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Button(action: {}, label: {
                        HStack {
                            Text("없음")
                                .font(.pretendard(.regular, size: 15))
                                .foregroundStyle(Color.mainText)
                            
                            Image(asset: SharedDesignSystemAsset.Assets.icRight)
                        }
                    })
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 30)
                
                photoPickerView.padding(.horizontal, 20)
                
                Spacer().frame(height: 20)
                
                Image(asset: SharedDesignSystemAsset.Assets.line)
                
                HStack {
                    Text("활동 참석자")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Button(action: {}, label: {
                        HStack {
                            Text("없음")
                                .font(.pretendard(.regular, size: 15))
                                .foregroundStyle(Color.mainText)
                            
                            Image(asset: SharedDesignSystemAsset.Assets.icRight)
                        }
                    })
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                
                Image(asset: SharedDesignSystemAsset.Assets.line)
                
                HStack {
                    Text("활동 정산")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    Button(action: {}, label: {
                        HStack {
                            Text("총 0원")
                                .font(.pretendard(.regular, size: 15))
                                .foregroundStyle(Color.mainText)
                            
                            Image(asset: SharedDesignSystemAsset.Assets.icRight)
                        }
                    })
                }
                .padding(.top, 16)
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.15), radius: 6)
        .padding(.horizontal, 25)
    }
}

// MARK: - 활동 기록 추가
extension DiaryEditView {
    private var addActivityButton: some View {
        Button(action: {
            tabItems.append(tabItems.count)
        }, label: {
            HStack(spacing: 12) {
                Image(asset: SharedDesignSystemAsset.Assets.icDiary)
                Text("활동 추가")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(.white)
        })
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 1)
        )
    }
}

// MARK: - 저장
extension DiaryEditView {
    private var saveButton: some View {
        Button(action: {}, label: {
            Text("기록 저장")
                .font(.pretendard(.bold, size: 15))
                .frame(maxWidth: .infinity, minHeight: 82)
                .foregroundColor(.white)
        })
        .background(Color.namoOrange)
    }
}

extension DiaryEditView {
    private var navigationTitle: some View {
        Text("나모 3기 회식")
            .font(.pretendard(.bold, size: 22))
    }
}
