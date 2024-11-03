//
//  MoimCreateView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/11/24.
//

//
//  MoimCreateView.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/11/24.
//

import SwiftUI
import PhotosUI

import ComposableArchitecture
import Kingfisher

import FeatureMoimInterface
import FeaturePlaceSearchInterface
import SharedUtil
import SharedDesignSystem


public struct MoimScheduleEditView: View {
    @Perception.Bindable private var store: StoreOf<MoimEditStore>
    @Perception.Bindable private var placeStore: StoreOf<PlaceSearchStore>
    @State var draw = false
    
    public init(store: StoreOf<MoimEditStore>) {
        self.store = store
        self.placeStore = .init(initialState: PlaceSearchStore.State(), reducer: {
            PlaceSearchStore()
        })
    }
    
    
    /// 편집여부에 따라 보여지는 텍스트 설정
    private var title: String {
        switch store.mode {
        case .compose:  "새 모임 일정"
        case .edit: "모임 일정 편집"
        case .view: "모임 일정"
        }
    }
    
    /// 편집여부에 따라서 보여지는 버튼 텍스트 설정
    private var buttonTitle: String {
        switch store.mode {
        case .compose: "생성"
        case .edit: "저장"
        case .view: ""
        }
    }
    
    public  var body: some View {
        WithPerceptionTracking {
            VStack {
                // deleteButton
                DeleteCircleButton {
                    store.send(.deleteButtonTapped)
                }
                .offset(y: 20)
                //                .opacity(!store.moimSchedule.isOwner ? 0 : 1)
                
                WithPerceptionTracking {
                    VStack(spacing: 0) {
                        // title
                        headerView
                            .padding(.horizontal, 20)
                        
                        // content
                        ScrollView {
                            VStack(spacing: 30) {
                                // textField
                                TextField("내 모임", text: $store.moimSchedule.title)
                                    .font(.pretendard(.bold, size: 22))
                                    .foregroundStyle(Color.mainText)
                                    .padding(.top, 20)
                                
                                // imagePicker
                                imagePickerView
                                
                                // 장소, 시간
                                settingView
                                
                                // 친구 초대
                                participantListView
                                
                                // 일정보기 버튼
                                showScheduleButton
                            }
                            .padding(.horizontal, 30)
                        }
                    }
                }
                .background(.white)
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 15,
                    topTrailing: 15)))
                .shadow(radius: 10)
            }
            .edgesIgnoringSafeArea(.bottom)
            .namoAlertView(isPresented: $store.isAlertPresented,
                           title: "모임 일정에서 정말 나가시겠어요?",
                           content: "모임 일정과 해당 일정의 기록을 \n 더 이상 보실 수 없습니다.",
                           confirmAction: {
                store.send(.deleteButtonConfirm)
            })
            .background(ClearBackground())
        }
    }
}

extension MoimScheduleEditView {
    
    /// 일정 보기
    private var showScheduleButton: some View {
        Button(action: {}, label: {
            HStack(spacing: 12) {
                Image(asset: SharedDesignSystemAsset.Assets.icCalendar)
                Text("초대한 친구 일정 보기")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(.black)
            }
            .background(.white)
            .padding(.vertical, 11)
            .padding(.horizontal, 20)
        })
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 1)
        )
    }
    
    /// 헤더뷰
    private var headerView: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                store.send(.cancleButtonTapped)
            }, label: {
                Text("취소")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(Color.mainText)
            })
            
            Spacer()
            
            Text(title)
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.black)
            
            Spacer()
            
            if store.mode == .view {
                Text("취소")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(Color.white)
            } else {
                Button(action: {
                    store.send(.createButtonTapped)
                }) {
                    Text(buttonTitle)
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                }
            }
            
        }
        .frame(height: 48)
    }
    
    /// 커버이미지 피커
    private var imagePickerView: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text("커버 이미지")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                
                Text("추후 변경 가능")
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(Color.mainText)
            }
            
            Spacer()
            
            PhotosPicker(selection: $store.coverImageItem, matching: .images) {
                if let coverImage = store.coverImage {
                    Image(uiImage: coverImage)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(5)
                } else if !store.moimSchedule.imageUrl.isEmpty {
                    KFImage(URL(string: store.moimSchedule.imageUrl))
                        .placeholder({
                            Image(asset: SharedDesignSystemAsset.Assets.appLogo)
                        })
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(5)
                } else {
                    Image(asset: SharedDesignSystemAsset.Assets.addPicture)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(5)
                }
            }
        }
    }
    
    /// 날짜선택
    private var settingView: some View {
        VStack(spacing: 20) {
            VStack {
                HStack {
                    Text("시작")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    
                    Text(store.moimSchedule.startDate.toYMDEHM())
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                        .onTapGesture {
                            store.send(.startPickerTapped)
                        }
                }
                
                if store.isStartPickerPresented {
                    DatePicker("startTimeDatePicker", selection: $store.moimSchedule.startDate)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .tint(Color.mainOrange)
                }
            }
            
            VStack {
                HStack {
                    Text("종료")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    
                    Spacer()
                    Text(store.moimSchedule.endDate.toYMDEHM())
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                        .onTapGesture {
                            store.send(.endPickerTapped)
                        }
                }
                
                if store.isEndPickerPresented {
                    DatePicker("endTimeDatePicker", selection: $store.moimSchedule.endDate)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .tint(Color.mainOrange)
                }
            }
            
            VStack(spacing: 20) {
                HStack {
                    Text("장소")
                        .font(.pretendard(.bold, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer()
                    
                    Button(action: {
                        store.send(.goToKakaoMapView)
                    }) {
                        HStack(spacing: 8) {
                            Text(store.moimSchedule.locationName)
                                .font(.pretendard(.regular, size: 15))
                                .foregroundStyle(Color.mainText)
                            
                            Image(asset: SharedDesignSystemAsset.Assets.icRight)
                        }
                    }
                }
                
                if !store.moimSchedule.kakaoLocationId.isEmpty {
                    KakaoMapView(store: placeStore, draw: $draw)
                        .id(store.moimSchedule.kakaoLocationId)
                        .onAppear {
                            placeStore.x = store.moimSchedule.latitude
                            placeStore.y = store.moimSchedule.longitude
                            draw = true
                        }
                        .onDisappear { draw = false }
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity, minHeight: 190)
                        .border(Color.textUnselected, width: 1)
                }
            }
        }
    }
    
    /// 참가자 리스트
    private var participantListView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("친구 초대하기")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                
                Button(action: {
                    store.send(.goToFriendInvite)
                }) {
                    Image(asset: SharedDesignSystemAsset.Assets.icRight)
                }
            }
            
            FlexibleGridView(data: store.moimSchedule.participants) { participant in
                Participant(name: participant.nickname,
                            color: PalleteColor(rawValue: participant.colorId ?? 1)?.color ?? .clear,
                            isOwner: participant.isOwner)
            }
        }
    }
}
