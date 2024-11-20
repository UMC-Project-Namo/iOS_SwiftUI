//
//  ScheduleEditView.swift
//  FeatureGatheringSchedule
//
//  Created by 권석기 on 11/20/24.
//

import SwiftUI

import FeatureLocationSearchInterface
import SharedDesignSystem

import ComposableArchitecture

public struct ScheduleEditView: View {
    @Perception.Bindable private var store: StoreOf<GatheringScheduleStore>
    @State private var draw = false
    public init(store: StoreOf<GatheringScheduleStore>) {
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
                        friendSetting
                    }
                }
                .padding(.horizontal, 30)
                .background(.white)
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                    topLeading: 15,
                    topTrailing: 15)))
                .shadow(radius: 10)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(ClearBackground())
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
            
        }
    }
}

extension ScheduleEditView {
    private var headerView: some View {
        HStack {
            cancleButton
            Spacer()
            Text("새 모임 일정")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.colorBlack)
            Spacer()
            saveButton
        }
        .padding(.vertical, 15)
    }
}

extension ScheduleEditView {
    private var cancleButton: some View {
        Button(action: {}, label: {
            Text("취소")
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        })
    }
}

extension ScheduleEditView {
    private var saveButton: some View {
        Button(action: {}, label: {
            Text("저장")
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        })
    }
}

extension ScheduleEditView {
    private var textField: some View {
        TextField("내 모임", text: $store.title)
            .font(.pretendard(.bold, size: 22))
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
            
            Image(asset: SharedDesignSystemAsset.Assets.addPicture)
        }
    }
}

extension ScheduleEditView {
    private var startDatePicker: some View {
        HStack {
            Text("시작")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            Spacer()
            Text("2024.08.07 (수) 08:00 AM")
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        }
    }
    
    private var endDatePicker: some View {
        HStack {
            Text("종료")
                .font(.pretendard(.bold, size: 15))
                .foregroundStyle(Color.mainText)
            Spacer()
            Text("2024.08.07 (수) 08:00 AM")
                .font(.pretendard(.regular, size: 15))
                .foregroundStyle(Color.mainText)
        }
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
                Spacer().frame(height: 28)
            }
        }
    }
}

extension ScheduleEditView {
    private var friendSetting: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("친구초대")
                    .font(.pretendard(.bold, size: 15))
                    .foregroundStyle(Color.mainText)
                Spacer()
                Image(asset: SharedDesignSystemAsset.Assets.icRight)
            }
            Text("일정을 생성한 이후에는 초대한 친구를 삭제할 수 없습니다.")
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(Color.textDisabled)
        }
    }
}

