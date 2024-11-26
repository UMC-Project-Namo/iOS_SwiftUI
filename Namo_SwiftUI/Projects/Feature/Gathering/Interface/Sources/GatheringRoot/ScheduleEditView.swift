//
//  ScheduleEditView.swift
//  FeatureGatheringSchedule
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI
import PhotosUI

import DomainFriend
import FeatureLocationSearchInterface
import SharedDesignSystem

import ComposableArchitecture
import Kingfisher

public struct ScheduleEditView: View {
    @Perception.Bindable private var store: StoreOf<GatheringRootStore>
    @State private var draw = false
    
    public init(store: StoreOf<GatheringRootStore>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer().frame(height: 6)
                deleteScheduleButton
                Spacer().frame(height: 6)
                VStack(spacing: 0) {
                    headerView
                    ScrollView {
                        Spacer().frame(height: 12)
                        textField
                        Spacer().frame(height: 30)
                        imagePicker
                        Spacer().frame(height: 30)
                        startDatePicker
                        Spacer().frame(height: 20)
                        endDatePicker
                        Spacer().frame(height: 20)
                        locationSetting
                        mapPreview
                        Spacer().frame(height: 30)
                        friendList
                        Spacer().frame(height: 36)
                        showScheduleButton
                        Spacer().frame(height: 16)
                        showDiaryButton
                    }
                }
                .background(.white)
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 15,
                    topTrailing: 15)))
                .shadow(radius: 10)
            }
        }
        .namoAlertView(isPresented: $store.showingDeleteAlert,
                       title: "모임 일정에서 정말 나가시겠어요?",
                       content: "모임 일정과 해당 일정의 기록을 더 이상 보실 수 없으며, 방장 권한이 위임됩니다.",
                       confirmAction: { store.send(.deleteButtonConfirm) })
        .edgesIgnoringSafeArea(.bottom)
        .background(ClearBackground())
        .onAppear { store.send(.friendList(.searchButtonTapped)) }
    }
}

extension ScheduleEditView {
    private var deleteScheduleButton: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 40, height: 40)
                .shadow(radius: 2)
            
            Image(asset: SharedDesignSystemAsset.Assets.icDeleteSchedule)
                .resizable()
                .frame(width: 24, height: 24)
            
        }
        .onTapGesture {
            store.send(.deleteButtonTapped)
        }
    }
}

extension ScheduleEditView {
    private var headerView: some View {
        HStack {
            cancleButton
            Spacer()
            headerContent
            Spacer()
            saveButton
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
    }
}

extension ScheduleEditView {
    private var headerContent: some View {
        Group {
            switch store.editMode {
            case .compose:
                Text("새 모임 일정")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.colorBlack)
            case .edit:
                Text("모임 일정 편집")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.colorBlack)
            case .view:
                Text("모임 일정")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.colorBlack)
            }
        }
    }
}

extension ScheduleEditView {
    private var cancleButton: some View {
        Button(action: {
            store.send(.cancleButtonTapped)
        }, label: {
            Text("취소")
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        })
    }
}

extension ScheduleEditView {
    private var saveButton: some View {
        Group {
            switch store.editMode {
            case .compose:
                Button(action: {
                    store.send(.createButtonTapped)
                }, label: {
                    Text("생성")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                })
            case .edit:
                Button(action: {
                    store.send(.createButtonTapped)
                }, label: {
                    Text("저장")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                })
            case .view:
                EmptyView()
            }
        }
    }
}

extension ScheduleEditView {
    private var textField: some View {
        TextField("내 모임", text: $store.schedule.title)
            .font(.pretendard(.bold, size: 22))
            .foregroundStyle(Color.mainText)
            .padding(.horizontal, 30)
    }
}

extension ScheduleEditView {
   
    private var imagePicker: some View {
        HStack {
            Text("커버 이미지")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
                .frame(alignment: .topLeading)
            
            Spacer()
            
            PhotosPicker(selection: $store.schedule.coverImageItem, matching: .images) {
                if let coverImage = store.schedule.coverImage {
                    Image(uiImage: coverImage)
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(5)
                } else if !store.schedule.imageUrl.isEmpty {
                    KFImage(URL(string: store.schedule.imageUrl))
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
            .onChange(of: store.schedule.coverImageItem, perform: { imageItem in
                store.send(.schedule(.selectedImageItem(imageItem)))
            })
        }
        .padding(.horizontal, 30)
    }
}

extension ScheduleEditView {
    private var startDatePicker: some View {
        VStack {
            HStack {
                Text("시작")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Text(store.schedule.startDate.toYMDEHM())
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(Color.mainText)
                    .onTapGesture {
                        store.send(.schedule(.startPickerTapped))
                    }
            }
            if store.schedule.isStartPickerPresented {
                DatePicker("startTimeDatePicker", selection: $store.schedule.startDate)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(Color.mainOrange)
            }
        }
        .padding(.horizontal, 30)
    }
    
    private var endDatePicker: some View {
        VStack {
            HStack {
                Text("종료")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Text(store.schedule.endDate.toYMDEHM())
                    .font(.pretendard(.regular, size: 15))
                    .foregroundStyle(Color.mainText)
                    .onTapGesture {
                        store.send(.schedule(.endPickerTapped))
                    }
            }
            
            if store.schedule.isEndPickerPresented {
                DatePicker("endTimeDatePicker", selection: $store.schedule.endDate)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(Color.mainOrange)
            }
        }
        .padding(.horizontal, 30)
    }
    
    private var locationSetting: some View {
        VStack {
            let hasLocation = !store.kakaoMap.kakaoLocationId.isEmpty
            
            HStack {
                Text("장소")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Button(action: {
                    store.send(.goToLocationSearch)
                }, label: {
                    Text(hasLocation ? store.kakaoMap.locationName : "없음")
                        .font(.pretendard(.regular, size: 15))
                        .foregroundStyle(Color.mainText)
                    Spacer().frame(width: 8)
                    Image(asset: SharedDesignSystemAsset.Assets.icRight)
                })
            }
        }
        .padding(.horizontal, 30)
    }
}

extension ScheduleEditView {
    private var mapPreview: some View {
        VStack {
            let hasLocation = !store.kakaoMap.kakaoLocationId.isEmpty
            
            if hasLocation {
                Spacer().frame(height: 20)
                KakaoMapView(store: store.scope(state: \.kakaoMap, action: \.kakaoMap), draw: $draw)
                    .onAppear { draw = true }
                    .onDisappear { draw = false }
                    .allowsHitTesting(false)
                    .frame(maxWidth: .infinity, minHeight: 190)
                    .border(Color.textUnselected, width: 1)
            }
        }
        .padding(.horizontal, 30)
    }
}

extension ScheduleEditView {
    private var friendList: some View {
        VStack(alignment: .leading) {
            let friendList: [Friend] = store.friendList.addedFriendList.map { $0 }
            
            HStack {
                Text("친구초대")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Image(asset: SharedDesignSystemAsset.Assets.icRight)
                    .onTapGesture {
                        store.send(.goToFriendInvite)
                    }
            }.padding(.horizontal, 30)
            
            Text("일정을 생성한 이후에는 초대한 친구를 삭제할 수 없습니다.")
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(Color.textDisabled)
                .padding(.horizontal, 30)
            
            Spacer().frame(height: 12)
            
            FlexibleGridView(data: friendList) { friend in
                Participant(name: friend.nickname, pallete: PalleteColor(rawValue: friend.favoriteColorId) ?? .colorOrange)
            }
            .padding(.horizontal, 30)
            .id(friendList.count)
        }
    }
}

extension ScheduleEditView {
    private var showScheduleButton: some View {
          Button(action: {
          }, label: {
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
}

extension ScheduleEditView {
    private var showDiaryButton: some View {
        Button(action: {
            
        }, label: {
            HStack {
                Image(asset: SharedDesignSystemAsset.Assets.icDiary)
                    .renderingMode(.template)
                
                Text("기록하기")
                    .font(.pretendard(.bold, size: 15))
            }
            .foregroundStyle(Color.white)
            .padding(.vertical, 11)
            .padding(.horizontal, 20)
            .frame(maxWidth: 136, maxHeight: 40)
        })
        .background(Color.namoOrange)
        .cornerRadius(20)
    }
}
