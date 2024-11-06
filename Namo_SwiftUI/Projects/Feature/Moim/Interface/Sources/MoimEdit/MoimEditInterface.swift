//
//  MoimScheduleStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 9/24/24.
//

import SwiftUI
import UIKit
import PhotosUI

import DomainMoimInterface
import DomainPlaceSearchInterface
import DomainFriend

import ComposableArchitecture

/**
 Reducer for MoimEdit(모임 편집) Feature
*/
@Reducer
public struct MoimEditStore {
    
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    /// 편집 여부
    public enum Mode: Equatable {
        case view, edit, compose
    }
    
    @ObservableState
    public struct State: Equatable {
        
        /// 편집 여부
        public var mode: Mode = .compose
        
        /// 모임일정
        public var moimSchedule: MoimSchedule
        
        /// 커버이미지
        public var coverImageItem: PhotosPickerItem?
        
        /// 커버이미지
        public var coverImage: UIImage?
        
        /// 시작 날짜 선택 캘린더 보임여부
        public var isStartPickerPresented: Bool = false
        
        /// 종료 날짜 선택 캘린더 보임여부
        public var isEndPickerPresented: Bool = false
        
        /// 삭제 알림 보임여부
        public var isAlertPresented: Bool = false
        
        /// 모임일정 조회, 편집 initializer
        public init(moimSchedule: MoimSchedule) {
            self.moimSchedule = moimSchedule
            mode = self.moimSchedule.isOwner ? .edit : .view            
        }
        
        /// 모임일정 생성 initializer
        public init() {
            self.moimSchedule = .init()
        }
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
        
        /// 생성확인
        case createButtonConfirm
        
        /// 취소버튼 탭
        case cancleButtonTapped
        
        /// 삭제버튼 탭
        case deleteButtonTapped
        
        /// 삭제확인
        case deleteButtonConfirm     
        
        /// 삭제처리 완료
        case deleteConfirm
        
        /// 지도검색 이동
        case goToKakaoMapView
        
        /// 친구초대 이동
        case goToFriendInvite
                
        /// 위치정보 업데이트
        case locationUpdated(LocationInfo)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        reducer
    }
}


