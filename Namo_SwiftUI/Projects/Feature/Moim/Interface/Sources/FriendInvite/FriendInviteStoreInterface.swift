//
//  FriendInviteStoreInterface.swift
//  FeatureMoim
//
//  Created by 권석기 on 11/3/24.
//

import Foundation

import DomainFriendInterface
import DomainFriend

import ComposableArchitecture

/**
 Reducer for FriendInvite(친구초대) Feature
 */
@Reducer
public struct FriendInviteStore {
    private let reducer: Reduce<State, Action>
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        /// 검색어
        public var searchText = ""
        
        /// 친구목록
        public var friendList: [Friend] = []
        
        /// 추가한 친구목록
        public var addedFriend: [Friend] = []
    }
    
    public enum Action: BindableAction {
        
        /// 바인딩액션
        case binding(BindingAction<State>)
        
        /// 검색결과탭
        case searchButtonTapped
        
        /// 검색결과 응답
        case searchResponse(FriendResponse)
        
        /// 친구 추가
        case addFriend(Friend)
        
        /// 초대친구 삭제
        case removeFriend(memberId: Int)
        
        /// 뒤로가기
        case backButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        reducer
    }
}
