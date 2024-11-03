//
//  DiaryEditView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/13/24.
//

import SwiftUI
import PhotosUI

import SharedDesignSystem

public struct DiaryEditView: View {
    @State private var showingParticipants = false
    @State private var text = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = ""
    @State private var tabItems: [Int] = [0]
    @State private var selection = 0
    @State private var showingAlert = false
    @State private var showingAlert2 = false
    @State private var showingParticipantView = false
    @State private var showingCalculateView = false
    @State private var showingTagView = false
    @State private var participants: [String] = []
    @State private var myTag = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var seletedImages: [UIImage] = []
    
    @FocusState private var textEditorFocused: Bool
    
    private let dummyFriends = ["코코아", "다나", "유즈", "루카", "뚜뚜", "캐슬", "고흐", "연현", "초코", "짱구"]
    private let tags = ["없음", "술", "식사", "동창회", "공부"]
    
    public init() {}
    
    public var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    dateView
                        .padding(.horizontal, 30)
                    participantListView
                        .padding(.horizontal, 30)
                    
                    TabView(selection: $selection) {
                        
                        ForEach(tabItems, id: \.self) { index in
                            if index == tabItems.count - 1 {
                                diaryEditView
                            }
                            else {
                                activityView
                            }
                        }
                        
                    }
                    .frame(height: 430)
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
                    
                    addRecordButton
                }
                
                .padding(.bottom, 25)
            }
            
            Spacer()
            
            Button(action: {}, label: {
                Text("기록 저장")
                    .font(.pretendard(.bold, size: 15))
                    .frame(maxWidth: .infinity, minHeight: 82)
                    .foregroundColor(.white)
            })
            .background(Color.mainOrange)
        }
        .namoNabBar(center: {
            Text("나모 3기 회식")
                .font(.pretendard(.bold, size: 22))
                .foregroundStyle(.black)
        }, left: {
            Button(action: {
                showingAlert2 = true
            }, label: {
                Image(asset: SharedDesignSystemAsset.Assets.icArrowLeftThick)
            })
        })
        .namoAlertView(isPresented: $showingAlert, title: "활동을 삭제하시겠어요?", content: "삭제한 모임 활동은 \n 모든 참석자의 기록에서 삭제됩니다.", confirmAction: {
            
        })
        .namoAlertView(isPresented: $showingAlert2, title: "편집된 내용이 저장되지 않습니다.", content: "정말 나가시겠어요?")
        .namoPopupView(isPresented: $showingParticipantView,
                       title: "활동 참석자",
                       content: {
            selecteParticipantView
        }, confirmAction: {
            
        })
        .namoPopupView(isPresented: $showingCalculateView,
                       title: "정산 페이지",
                       content: {
            calculateView
        }, confirmAction: {
            
        })
        .namoPopupView(isPresented: $showingTagView, title: "태그", content: {
            tagView
        }, confirmAction: {
            
        })
        .edgesIgnoringSafeArea(.bottom)
    }
}

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
        }.padding(.vertical, 20)
    }
    
    private var participantListView: some View {
        VStack(spacing: 0) {
            HStack {
                Text("참석자 (10)")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                
                Spacer()
                
                Button(action: {
                    showingParticipants.toggle()
                }, label: {
                    Image(asset: SharedDesignSystemAsset.Assets.icUp)
                        .rotationEffect(.degrees(showingParticipants ? 180 : 0))
                        .animation(.none)
                })
            }
            
            if showingParticipants {
                ParticipantListView(friendList: dummyFriends)
            }
            
        }
    }
    
    private var diaryEditView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // header
                HStack {
                    Text("일기장")
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Image(asset: SharedDesignSystemAsset.Assets.icPrivate)
                        .renderingMode(.template)
                        .foregroundColor(Color.textPlaceholder)
                }
                
                // heart
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
                
                // texteditor
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
        .shadow(color: .black.opacity(0.15),
                radius: 6)
        .padding(.horizontal, 30)
    }
    
    private var activityView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                // textfield
                HStack {
                    TextField("활동 이름", text: $text2)
                        .font(.pretendard(.bold, size: 18))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        Image(asset: SharedDesignSystemAsset.Assets.icTrash)
                            .renderingMode(.template)
                            .foregroundStyle(Color.textUnselected)
                            .overlay {
                                Circle()
                                    .stroke(Color.textUnselected, lineWidth: 1)
                                    .frame(width: 40, height: 40)
                            }
                    })
                }
                
                // form
                VStack(spacing: 16) {
                    HStack {
                        Text("활동 참석자")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        Spacer()
                        
                        Button(action: {
                            showingParticipantView = true
                        }) {
                            HStack(spacing: 8) {
                                Text(participants.isEmpty ? "없음" : participants.map { $0 }.joined(separator: ","))
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(Color.mainText)
                                    .lineLimit(1)
                                
                                Image(asset: SharedDesignSystemAsset.Assets.icRight)
                            }
                        }
                    }
                    
                    HStack {
                        Text("시작")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                        Spacer()
                        
                        Text("2024.08.07 (수) 08:00 AM")
                            .font(.pretendard(.regular, size: 15))
                            .foregroundStyle(Color.mainText)
                    }
                    
                    HStack {
                        Text("종료")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                        Spacer()
                        
                        Text("2024.08.07 (수) 08:00 AM")
                            .font(.pretendard(.regular, size: 15))
                            .foregroundStyle(Color.mainText)
                    }
                    
                    HStack {
                        Text("장소")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        Spacer()
                        
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Text("없음")
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(Color.mainText)
                                
                                Image(asset: SharedDesignSystemAsset.Assets.icRight)
                            }
                        }
                    }
                    
                    HStack {
                        Text("정산")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        Spacer()
                        
                        Button(action: {
                            showingCalculateView = true
                        }) {
                            HStack(spacing: 8) {
                                Text("총 0원")
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(Color.mainText)
                                
                                Image(asset: SharedDesignSystemAsset.Assets.icRight)
                            }
                        }
                    }
                    
                    HStack {
                        Text("태그")
                            .font(.pretendard(.bold, size: 15))
                            .foregroundStyle(Color.mainText)
                        Spacer()
                        
                        Button(action: {
                            showingTagView = true
                        }) {
                            HStack(spacing: 8) {
                                Text(myTag.isEmpty ? "없음" : myTag)
                                    .font(.pretendard(.regular, size: 15))
                                    .foregroundStyle(Color.mainText)
                                
                                Image(asset: SharedDesignSystemAsset.Assets.icRight)
                            }
                        }
                    }
                }
                .padding(.top, 20)
                
                // image
                photoPickerView
                    .padding(.top, 47)
            }
            .padding(20)
        }.background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.15),
                    radius: 6)
            .padding(.horizontal, 30)
    }
    
    private var addRecordButton: some View {
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
    
    private var selecteParticipantView: some View {
        VStack {
            let item = GridItem(.flexible(), spacing: 0)
            let columns = Array(repeating: item, count: 2)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                ForEach(dummyFriends, id: \.self) { name in
                    HStack(spacing: 16) {
                        Image(asset: participants.contains(name) ? SharedDesignSystemAsset.Assets.icCheckCircleSelected : SharedDesignSystemAsset.Assets.icCheckCircle)
                            .onTapGesture {
                                if participants.contains(name) {
                                    participants = participants.filter { $0 != name }
                                } else {
                                    participants.append(name)
                                }
                            }
                        
                        Text(name)
                            .font(.pretendard(.regular, size: 15))
                            .foregroundStyle(Color.mainText)
                    }
                }
            }
        }
        .padding(35)
    }
    
    private var calculateView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 13) {
                HStack(spacing: 97) {
                    Text("총 금액")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    VStack {
                        TextField("금액 입력", value: $text3, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .font(.pretendard(.regular, size: 15))
                            .foregroundStyle(Color.mainText)
                        
                            .padding(6)
                            .padding(.leading, 52)
                    }
                    .background(Color.mainGray)
                    .cornerRadius(5)
                }
                
                HStack {
                    Text("인원 수")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Image(asset: SharedDesignSystemAsset.Assets.icDivision)
                    
                    Spacer()
                    
                    Text("총 \(participants.count)명")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                
                HStack {
                    Text("인당 금액")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Text("0 원")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
            }
            
            VStack {
                let item = GridItem(.flexible(), spacing: 0)
                let columns = Array(repeating: item, count: 2)
                
                LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                    ForEach(dummyFriends, id: \.self) { name in
                        HStack(spacing: 16) {
                            Image(asset: participants.contains(name) ? SharedDesignSystemAsset.Assets.icCheckCircleSelected : SharedDesignSystemAsset.Assets.icCheckCircle)
                                .onTapGesture {
                                    if participants.contains(name) {
                                        participants = participants.filter { $0 != name }
                                    } else {
                                        participants.append(name)
                                    }
                                }
                            
                            Text(name)
                                .font(.pretendard(.regular, size: 15))
                                .foregroundStyle(Color.mainText)
                        }
                    }
                }
            }
            .padding(5)
        }
        .padding(35)
    }
    
    private var tagView: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(tags, id: \.self) { tag in
                HStack(spacing: 16) {
                    Image(asset: tag == myTag ? SharedDesignSystemAsset.Assets.icRatioCircleSelected : SharedDesignSystemAsset.Assets.icRatioCircle)
                        .onTapGesture {
                            if tag == myTag {
                                myTag = ""
                            } else {
                                myTag = tag
                            }
                        }
                    
                    Text(tag)
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                }
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 16) {
                    Image(asset: myTag == "custom" ? SharedDesignSystemAsset.Assets.icRatioCircleSelected : SharedDesignSystemAsset.Assets.icRatioCircle)
                        .onTapGesture {
                            if myTag == "custom" {
                                myTag = ""
                            } else {
                                myTag = "custom"
                            }
                        }
                    
                    Text("직접 설정: ")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
                
                VStack {
                    TextField("입력", text: $text4)
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.textPlaceholder)
                }
            }
        }
        .padding(35)
    }
    
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
            loadSelectedPhotos()
        })
    }
}

extension DiaryEditView {
    private func loadSelectedPhotos() {
        Task {
            seletedImages.removeAll()
            await withTaskGroup(of: (UIImage?, Error?).self) { groupTask in
                for photoItem in selectedItems {
                    groupTask.addTask {
                        do {
                            if let imageData = try await photoItem.loadTransferable(type: Data.self) {
                                
                                let image = UIImage(data: imageData)
                                // 중복이미지 제외
                                if seletedImages.contains(where: {$0.pngData() == image?.pngData()}) {
                                    return (nil, nil)
                                }
                                return (image, nil)
                            }
                            return (nil, nil)
                        } catch {
                            return (nil, error)
                        }
                    }
                }
                
                for await result in groupTask {
                    if let error = result.1 {
                        break
                    } else if let image = result.0 {
                        DispatchQueue.main.async {
                            seletedImages.append(image)
                        }
                    }
                }
            }
        }
    }
}



