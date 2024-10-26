//
//  MoimScheduleStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/24/24.
//

import SwiftUI
import UIKit
import PhotosUI
import ComposableArchitecture
import DomainMoimInterface


@Reducer
/// 모임 생성/편집/조회
public struct MoimEditStore {
    
    /// 편집 여부
    public enum Mode: Equatable {
        case view
        case edit
        case compose
    }
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public struct State: Equatable {
        /// 타이틀
        @BindingState public var title: String = ""
        
        /// 커버이미지
        @BindingState public var coverImageItem: PhotosPickerItem?
        
        /// 시작 날짜
        @BindingState public var startDate: Date = .now
        
        /// 종료 날짜
        @BindingState public var endDate: Date = .now
        
        /// 시작 날짜 선택 캘린더 보임여부
        @BindingState public var isStartPickerPresented: Bool = false
        
        /// 종료 날짜 선택 캘린더 보임여부
        @BindingState public var isEndPickerPresented: Bool = false
        
        /// 삭제 알림 보임여부
        @BindingState public var isAlertPresented: Bool = false
        
        /// 모임일정 id
        public var moimScheduleId: Int = 0
        
        /// 커버이미지 url
        public var imageUrl: String = ""
        
        /// 커버이미지
        public var coverImage: UIImage?
        
        /// 모임장소 좌표(위도)
        public var latitude = 0.0
        
        /// 모임장소 좌표(경도)*
        public var longitude = 0.0
        
        /// 모임장소명
        public var locationName = ""
        
        /// 카카오 locationId
        public var kakaoLocationId = ""
        
        /// 참석자 정보
        public var participants: [Participant] = []
        
        /// 방장 여부
        public var isOwner: Bool = false
        
        /// 편집 여부
        public var mode: Mode = .compose
        
        public init() {}
    }
    
    public enum Action: BindableAction, Equatable {
        /// 바인딩액션 처리
        case binding(BindingAction<State>)
        
        /// 이미지선택
        case selectedImage(UIImage)
        
        ///  시작 날짜 버튼탭
        case startPickerTapped
        
        /// 종료 날짜 버튼탭
        case endPickerTapped
        
        /// 모임생성 버튼탭
        case createButtonTapped
        
        /// 취소버튼 탭
        case cancleButtonTapped
        
        /// 삭제버튼 탭
        case deleteButtonTapped
        
        /// 삭제확인
        case deleteButtonConfirm     
        
        case goToKakaoMapView
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        reducer
    }
}


